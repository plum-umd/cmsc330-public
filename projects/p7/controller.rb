require "sqlite3"

module Menu
	def create_menu(name)
		@db.execute_batch "INSERT INTO Menus (Name) VALUES(\"#{name}\")"
	end

	def read_menu()
		menus = []

		@db.execute "SELECT RowID, Name FROM Menus" do |menu|
			id, name = menu[0], menu[1]
			menus << { :id => id, :name => name }
		end

		return menus
	end

	def update_menu(id, name)
		@db.execute_batch "UPDATE Menus SET Name = \"#{name}\" WHERE RowID = #{id}"
	end

	def delete_menu(id)
		@db.execute_batch "DELETE FROM Menus WHERE RowID = #{id}"
	end
end

module Item
	def create_item(menu, name, price, description)
		@db.execute_batch "INSERT INTO Items (Menu, Name, Price, Description) VALUES(#{menu}, \"#{name}\", #{price}, \"#{description}\")"
	end

	def read_item()
		items = []

		@db.execute "SELECT RowID, Menu, Name, Price, Description FROM Items" do |item|
			id, menu, name, price, description = item[0], item[1], item[2], item[3], item[4]
			items << { :id => id, :menu => menu, :name => name, :price => price, :description => description }
		end

		return items
	end

	def update_item(id, menu, name, price, description)
		@db.execute_batch "UPDATE Items SET Menu = #{menu}, Name = \"#{name}\", Price = #{price}, Description = \"#{description}\" WHERE RowID = #{id}"
	end

	def delete_item(id)
		@db.execute_batch "DELETE FROM Items WHERE RowID = #{id}"
	end
end


module User
	def create_user(name, password, admin, salary)
		@db.execute_batch "INSERT INTO Users (Name, Password, Admin, Salary) VALUES(\"#{name}\", \"#{password}\", #{admin}, #{salary})"
	end

	def read_user()
		users = []

		@db.execute "SELECT RowID, Name, Password, Admin, Salary FROM Users" do |user|
			id, name, password, admin, salary = user[0], user[1], user[2], user[3], user[4]
			users << {:id => id, :name => name, :password => password, :admin => admin, :salary => salary}
		end

		if not admin?(@session_id) then
			user_id = authorize(@session_id)
			users.select! { |u| u[:id] == user_id }
		end

		return users
	end

	def update_user(id, name, password, admin, salary)
		@db.execute_batch "UPDATE Users SET " +
			"Name = \"#{name}\", Password = \"#{password}\", " +
			"Admin = #{admin}, Salary = #{salary} WHERE RowID = #{id}"
	end

	def delete_user(id)
		@db.execute_batch "DELETE FROM Users WHERE RowID = #{id}"
	end
end

module Access
	def create_session()
		random = Random.new
		session_id = random.rand(1000000000)
		@db.execute_batch "INSERT INTO Sessions (SessionID, UserID) VALUES(#{session_id}, -1)"
		return session_id
	end

	def authenticate(name, password)
		session_id = create_session()
		user = nil

		@db.execute "SELECT RowID FROM Users WHERE Name = \"#{name}\" AND Password = \"#{password}\"" do |u|
			user_id = u[0]
			escalate(user_id, session_id)
			return session_id
		end

		return -1
	end

	def escalate(user_id, session_id)
		@db.execute_batch "UPDATE Sessions SET UserID = #{user_id} WHERE SessionID = #{session_id}"
	end

	def admin?(session_id)
		user_id = authorize(session_id)
		@db.execute "SELECT Admin FROM Users WHERE RowID = #{user_id}" do |user|
			admin = user[0]
			return admin == 1
		end
		return false
	end

	def authorize(session_id)
		@db.execute "SELECT UserID FROM Sessions WHERE SessionID = #{session_id}" do |session|
			user_id = session[0]
			return user_id
		end
		return -1
	end

	def delete_session(session_id)
		@db.execute_batch "DELETE FROM Sessions WHERE SessionID = #{session_id}"
	end

	def guard(page)
		return true
	end
end

module Terminal
	def shell(command)
		# navigate to the correct shell directory
		Dir.chdir @shell_pwd

		# if command is `cd` then navigate to and save the shell's new pwd
		if command =~ /cd\W+((?:[^\/]*\/)*.*)/ then
			if not $1 == "" then
				Dir.chdir $1
			else
				Dir.chdir command[3..-1]
			end

			@shell_pwd = Dir.pwd # update the shell directory
			Dir.chdir @controller_pwd # return to the controller's home directory
			return ""
		# otherwise execute the command
		else
			output = `#{command}`
			Dir.chdir @controller_pwd # return to the controller's home directory
			return output
		end
	end
end

#
# NOTICE: You DO NOT need to modify anything below this point.
#         Modifications below this point may cause you to FAIL
#         our tests.
#

module Util
	def collate_menus()
		menus = []
		result = { :menus => menus }
		id_to_name = {}

		read_menu.each do |menu|
			id, name = menu[:id], menu[:name]
			id_to_name[id] = name
			menus << { :name => name, :items => [] }
		end

		read_item.each do |item|
			menu, name, price, description = item[:menu], item[:name], item[:price], item[:description]
			(menus.find { |m| m[:name] == id_to_name[menu] })[:items] << { :name => name, :price => price, :description => description }
		end

		return result
	end
end

class Controller
	include Menu
	include Item
	include User
	include Access
	include Terminal
	include Util

	attr_accessor :session_id, :shell_pwd
	attr_reader :db, :controller_pwd

	def initialize()
		@db = SQLite3::Database.new "data.db"
		@shell_pwd = Dir.pwd
		@controller_pwd = Dir.pwd
		@session_id = -1
	end
end
