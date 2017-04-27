# This server draws inspiration from the Ruby ftpd project by Wayne Conrad

require 'socket'
#---------------------------------------------------------------------
#GENERAL FUNCTIONS

# used to send packets between client and server
def my_send(socket,data)
  if(data.length>=65536)
    puts "Packet too large, dropping"
  end
  strlen = []
  strlen[0] = (data.length>>24)&0xFF
  strlen[1] = (data.length>>16)&0xFF
  strlen[2] = (data.length>>8)&0xFF
  strlen[3] = (data.length)&0xFF
  tmp = 0x3.chr+0x30.chr+strlen.pack("CCCC")+data
  socket.write tmp
end
def recv_hdr socket
  hdr = socket.recv 6
	hdr_bytes = hdr.bytes.to_a
  if hdr == "" 
    puts "client disconnected"
    return -1
  elsif hdr.length != 6
    puts "Stub packet read" 
    return -1
  elsif(hdr_bytes[0] != 0x03 || hdr_bytes[1] != 0x30)
    puts "Corrupted packet read"
    return -1
  end
  len = hdr_bytes[2...6].join.to_i
  return len
end
def recv_body(s,len)
  ret = s.recv len
end
def my_recv s
  len = recv_hdr s
  if len == -1
    return ""
  end
  return recv_body(s,len)
end

#---------------------------------------------------------------------
#SERVER FUNCTIONS

@timeout=500
@public_files = []
@accounts=[]
@s2a={}
@logged_in = false

# The account class, stores each user's directory and other details
class Account
  attr_accessor :user
  attr_accessor :directory
  attr_accessor :password
  attr_accessor :socket
  attr_accessor :public_files
  def initialize(user,password,directory)
    @user = user
    @password = password
    @directory = File.join(Dir.pwd,"users",directory)
  end
end

# Read in the acountsiwe have stored in a file
def open_accounts
  File.open(File.join(Dir.pwd,"users","accounts")) do |f|
    f.each_line do |line|
      b=line.split(",")
      a=Account.new(b[0],b[1],b[2].delete("\n"))
      @accounts.push(a)
    end
  end
end

# This will be run exactly once per client connection, and will loop infinitely until the connection is cut
def start_session(socket)
  Thread.new do
    catch :done do
	    begin
	      my_send(socket, "Hi I'm a friendly FTP server")
	      loop do
            # select will make sure that ready will only be filled if the connection at the socket actually has been sent data by the client
            ready = IO.select([socket],nil,nil,@timeout)
            if ready.nil?
              my_send(socket, "Connection Timed Out. You've been Disconnected")
              throw :done
            end
            s = ready[0].first.gets
            throw :done if s.nil?
            s.chomp!
            s.delete!("\0")
            #This might help with debugging, it prints out the hex of whatever info the client might have sent. 
            #puts "0x" + s.bytes.to_a.map { |b| sprintf("%02X",b) }.join
            if s=~ /^(\w+)(?: ?(.*))$/
              command, argument = $1.downcase, $2
              puts "Executing #{command} #{argument} from #{socket.peeraddr[1]}"
              execute command,argument,socket
            elsif s.chomp !=""
              my_send(socket, "Syntax error")
            end
	      end
      rescue Errno::ECONNRESET, Errno::EPIPE
      ensure
        puts "Closed connection"
	socket.close
      end
    end
  end
end

#ensure that the socket has proper authentication
def logged_in socket
  @s2a[socket] && @logged_in
end

# What command do we want run?
def execute(command,argument,socket)
  if command=="user"
    user argument,socket
  elsif command=="pass" || command=="password"
    pass argument,socket
  elsif command=="get"
    get argument,socket
  elsif command=="put"
    put argument,socket
  elsif command=="ls"
    ls argument,socket
  elsif command=="exit"
    exitt socket
  else
    my_send(socket, "invalid command")
  end
end

# Downloads the file [path]. Files with the public/ prefix are treated specially.
def get(path,socket)
  unless logged_in socket
    my_send(socket, "ERRACC")
    return
  end
  my_send(socket, "GOGOGO")
  if path =~ /^public/ then
    full_path = File.join(Dir.pwd,"users",path)
  else
    full_path = File.join(@s2a[socket].directory,path)
  end
  if File.exist?(full_path) && !File.directory?(full_path)
    my_send(socket,"Got file #{path}")
    file = File.open(full_path, "rb")
    my_send(socket,file.read)
  else
    my_send(socket,"File #{path} not found")
  end
end

# Uploads the file [path]. Files with the public/ prefix are treated specially.
def put(path,socket)
  unless logged_in socket
    my_send(socket, "ERRACC")
    return
  end
  my_send(socket, "GOGOGO")
  data = my_recv socket
  if data != "IGNORE"
    if path =~ /^public/ then
      full_path = File.join(Dir.pwd,"users",path)
      if File.exists?(full_path)
        my_send(socket, "You do not have permissions to put that file there")
        return
      end
    else
      full_path = File.join(@s2a[socket].directory,path)
    end
    File.open(full_path, "wb") do |file|
      File.write(file,data)
    end
    my_send(socket, "Put file #{path}, size #{File.size full_path} bytes")
  end
end

# Sets the current user's name
def user(arg,socket)
  arg.downcase!
  found=false
  if !arg || arg==""
    my_send(socket, "No username supplied")
    return
  end
  if @s2a[socket] && @logged_in && @s2a[socket].user == arg
    my_send(socket, "User already logged in")
    return
  end
  @accounts.each{|a|
    if(a.user==arg)
      @s2a[socket]=a
      found=true
      my_send(socket, "Welcome #{arg}")
    end
  }
  if !found
    my_send(socket, "Username #{arg} not found")
  end
end

# Provides password for the current user, to log in
def pass(arg,socket)
  if !@s2a[socket]
    my_send(socket, "Must supply Username first")
    return
  end
  if @s2a[socket].password==arg
    my_send(socket, "Hi #{@s2a[socket].user}, you are now logged in")
    @logged_in=true
  else
    my_send(socket, "Incorrect password")
  end
end

# Lists files. If the argument is "" then it lists the current user's
# files. If it is "public" it lists the files in the public directory
def ls(arg,socket)
  unless logged_in socket
    my_send(socket, "You're not logged in yet")
    return
  end
  if arg =~ /^public/ then
    path = File.join(Dir.pwd,"users",arg)
    my_send(socket, "Index: \n#{`ls #{path}`}")
  elsif arg == "" then
    path = @s2a[socket].directory
    my_send(socket, "Index: \n#{`ls #{path}`}")
  else
    my_send(socket, "Listed directory can be only none or public")
  end
end

# Called with the user logs out
def exitt(socket)
  if @s2a[socket]
    my_send(socket, "User #{@s2a[socket].user} logged out")
    @s2a[socket]=nil
  else
    my_send(socket, "No user logged in")
  end
end

# this is the main thread of the server part of the program
# run infinitely to accept new client connections.
# (Don't worry so much about the errors we're rescuing.)
def serve port
  open_accounts
  puts "Starting server on TCP port #{port}"
  listen_socket=TCPServer.new("127.0.0.1",port)
  Thread.abort_on_exception = true
  loop do
    begin
      begin
        socket = listen_socket.accept
      rescue Errno::EAGAIN, Errno::ECONNABORTED, Errno::EPROTO, Errno::EINVAL
        IO.select([1337])
        sleep(0.2)
        retry
      rescue Errno::EBADF, Errno::ENOTSOCK
        break
      end
      start_session socket  
    rescue IOError
      break
    end
  end
end

#---------------------------------------------------------------------
# MAIN FUNCTION. Sets the port and starts serving connections.
def main
  if ARGV.length > 0
    port = ARGV[0].to_i
    if port< 1024 || port > 49151
      puts "illegal port #{ARGV[0].to_i}: Choose one in range 1024-49151"
      exit
    end
  else
    port = Random.new.rand(48128) + 1024
  end
  serve port
end
main
