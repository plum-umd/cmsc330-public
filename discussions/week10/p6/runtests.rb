require 'rbconfig'
tests_passed = 0

if ARGV.length > 0 then
  port = ARGV[0].to_i
  if port< 1024 || port > 49151 then
    puts "illegal port: Choose one in range 1024-49151"
    exit 1
  end
else
	port = Random.new.rand(48128) + 1024
end

testdir = "tests"
if not (File.exists?(testdir) && File.directory?(testdir)) 
  puts "invalid test directory #{testdir}"
  exit 1
end
#pid = spawn(RbConfig.ruby,"ftp.rb","#{port}")
Dir.chdir(testdir)
files = Dir.entries(".") 
tester = "test.rb"
files.sort.each {|f|
  if f =~ /^test[0-9]+/
    # f = File.join(testdir,f)
    # puts "I'm calling ruby #{tester} #{f} #{port}"
    ret = system(RbConfig.ruby,tester,f,"#{port}")
		sleep(0.0001)
		puts "\n--------------------------"
    if !ret
      puts "You have failed public test #{f}, with return value #{ret}"
    else
      puts "#{f} passed"
      tests_passed += 1
    end
		puts "--------------------------\n"
  end
}
#Process.kill(2,pid)
puts
puts "You passed #{tests_passed} tests"
