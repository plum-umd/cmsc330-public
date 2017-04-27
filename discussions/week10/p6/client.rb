require 'socket'
#---------------------------------------------------------------------
#GENERAL FUNCTIONS

def my_send data
  if(data.length>=65536)
    puts "Packet too large, dropping"
  end
  strlen = []
  strlen[0] = (data.length>>24)&0xFF
  strlen[1] = (data.length>>16)&0xFF
  strlen[2] = (data.length>>8)&0xFF
  strlen[3] = (data.length)&0xFF
  tmp = 0x3.chr+0x30.chr+strlen.pack("CCCC")+data
  @socket.write tmp
end
def recv_hdr 
  hdr = @socket.recv 6
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
def recv_body len
  ret = @socket.recv len
end
def my_recv 
  len = recv_hdr
  if len == -1
    return ""
  end
  return recv_body len
end
#---------------------------------------------------------------------


def put path
  permissions = my_recv
  if permissions == "GOGOGO"
    if path =~ /^public\//
      path_cut = path.split(/\//)[1..-1].join("/")
    else
      path_cut = path
    end
    if File.exist?(path_cut) && !File.directory?(path_cut)
        file = File.open(path_cut, "rb")
        my_send file.read
        puts my_recv
    else
        my_send "IGNORE"
        puts "File #{path} not found"
    end
  else
    puts "You are not allowed to access a file" if permissions == "ERRACC"
  end
end

def get path
  permissions = my_recv
  if permissions == "GOGOGO"
    status = my_recv
    puts status
    if status =~ /^File .* not found$/
      return
    end
    if path =~ /^public\//
      path = path.split(/\//)[1..-1].join("/")
    end
    data = my_recv
    File.open(path, "wb") do |file|
      File.write(file,data)
    end
    puts "size #{File.size path} bytes"
  elsif permissions == "ERRACC"
    puts "You are not allowed to access a file"
  else
    puts "OOPS! got |#{permissions}|"
  end
end

def process command, argument
  @socket.puts command+" "+argument
  if command == "put"
    put argument
  elsif command == "get"
    get argument
  else
    puts my_recv
  end
end

#--------------------------------------------------------------------
if ARGV.length > 0 then
  port = ARGV[0].to_i
  if port< 1024 || port > 49151 then
    puts "illegal port: Choose one in range 1024-49151"
    exit 1
  end
else
  puts "need to provide port number to connect on (1024-49151)"
  exit 2
end

# Connect to the server
@socket = TCPSocket.new('localhost', port)
$stdout.sync = true
puts my_recv

loop do
    print ">"
    a = STDIN.gets
    if a.nil? then
      @socket.close
      exit 0
    end
    a.chomp!
    if a=~ /^(\w+)(?: ?(.*))$/
        command, argument = $1.downcase, $2
        process(command, argument)
    else
        puts "Incorrect command syntax, dropping"
    end
end

