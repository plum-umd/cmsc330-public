# Use this script to update the accounts file and the public tests to use new, randomly generated passwords.
# It should be run in the main distribution directory, where users/ users_unfutzed/ and tests/ are subdirectories

accounts_file = File.join("users_unfutzed","accounts")
if not File.exists?(accounts_file) then
  puts "missing accounts file #{accounts_file}"
  exit 1
end

other_accounts_file = File.join("users","accounts")
if not File.exists?(other_accounts_file) then
  puts "missing accounts file #{other_accounts_file}"
  exit 1
end

testdir = "tests"
if not (File.exists?(testdir) && File.directory?(testdir)) 
  puts "invalid test directory #{testdir}"
  exit 1
end

#######################
## Generate accounts file ##
#######################

# for generating random passwords
o = [('a'..'z'), ('A'..'Z'), ('0'..'9')].map { |i| i.to_a }.flatten

users = { }

# read the current accounts file
File.open(accounts_file,"rb") do |file|
  while line = file.gets
    userid,oldpass,directory = line.split(',')
    pass = (0...16).map { o[rand(o.length)] }.join
    users[oldpass] = [userid,pass,directory]
  end
end

# overwrite the file with entries having new passwords
File.open(accounts_file, "wb") do |file|
  users.each {|k,entry|
    userid,pass,directory = entry
    file.puts "#{userid},#{pass},#{directory}"
  }
end

# copy the file to the users directory
system("cp #{accounts_file} #{other_accounts_file}")

##################
## Update the tests ##
##################
example = File.join(testdir,"example.txt")
File.open(example,"wb") do |file|
  file.puts "I am an example file. Hello!"
end

oldpasses = users.keys
passregexp = Regexp.new(oldpasses.join("|"))
files = Dir.entries(testdir) 
files.each {|f|
  if f =~ /^test[0-9]+/ then
    f = File.join(testdir,f)
    lines = [ ]
    i = 0
    # read in the test file. If any line matches an old password, update it
    File.open(f,"rb") do |file|
      while line = file.gets
        if line =~ passregexp then
          oldpasses.each {|op|
            _,p,_ = users[op]
            # replace old password with new version
            line.sub!(op,p)
          }
        end
        lines[i] = line
        i += 1
      end
    end
    # rewrite the file with the changes made to it
    File.open(f,"wb") do |file|
      lines.each {|line|
        file.puts line
      }
    end
     puts "==== #{f} ===="
     lines.each {|line|
       puts line
     }
  end
}
