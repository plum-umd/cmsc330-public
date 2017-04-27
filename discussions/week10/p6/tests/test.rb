require 'pty'
require 'fileutils'
require 'expect'
raise "No test name given" unless ARGV.size>0
if ARGV.length > 1 then
	port = ARGV[1].to_i
	if port< 1024 || port > 49151 then
		puts "illegal port: Choose one in range 1024-49151"
		exit 1
	end
else
	puts "need to provide port number to connect on (1024-49151)"
	exit 2
end
tnum=ARGV.first
ncmds=0
arr=[]
#clean and redo system
FileUtils.rm_r "../users"
FileUtils.cp_r("../users_unfutzed","../users")
#open test file
buf = ""
i = 0
File.open(tnum) do |f|
	f.each_line do |l|
		if(l[0,1]=="<")
			buf.gsub!(/\n/,"\r\n")
                        #puts "putting #{buf} in array"
			arr[i]=[buf,0]
			buf=""
			arr[i+1] = [l[1..-1].strip,1]
                        i += 2
		else
			buf+=l
		end
	end
end
if buf!=""
	buf.gsub!(/\n/,"\r\n")
	arr[i] = [buf,0]
end
=begin
puts arr.inspect
=end

#spawn server
pwd = Dir.pwd
Dir.chdir("..")
serverpid = Process.spawn("ruby ftp.rb #{port}")
Dir.chdir(pwd)
sleep(1)

#run test
begin
path = "../client.rb"
PTY.spawn("ruby #{path} #{port}") {|o,i,t|
	i.sync = true
	o.sync = true
	pid = t
	arr.each do |k,v|
		IO.select([o])
		sleep(0.0002)
		if o
			if v==1
				ret = o.expect(">",2)[0].strip
				raise "TOO MUCH READ" unless ret.size == 1
				raise ">FAIL" unless ret == ">"
				print ret
				i.puts k
				IO.select([o])
				puts o.readpartial(k.size+2)
			else
                          loop do
			    if not (IO.select([o],[],[],3)) then
                              raise "TOO LITTLE READ: timeout"
                            end
			    rr = o.readpartial(k.size)
                            if k.start_with? rr then
                              if rr.size == k.size then break
                              else
                                #puts "|#{rr.inspect}|"
                                #puts "|#{k.inspect}|"
                                k = k[rr.size,k.size-rr.size]
                                #puts "updated to |#{k.inspect}|"
                              end
                            else
                              raise "OUTPUT UNMATCHED: |#{rr.inspect}| expecting |#{k.inspect}|"
                            end
			  end
                        end
		end
	end
}
rescue RuntimeError => e
  if not (Process.kill('TERM',serverpid)) then
    puts "couldn't kill server properly"
  else
    Process.wait
  end
  puts "FAILED: ",e.message
  exit 1
end

if not (Process.kill('TERM',serverpid)) then
  puts "couldn't kill server properly"
else
  Process.wait
end
puts "PASSED"
exit 
