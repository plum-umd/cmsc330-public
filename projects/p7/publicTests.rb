require "minitest/autorun"
require "securerandom"
require_relative "controller.rb"

def as_employee(controller)
	session_id = controller.authenticate("ocamlollie", "ocamlollie")
	controller.session_id = session_id
end

def as_admin(controller)
	session_id = controller.authenticate("lambdalou", "lambdalou")
	controller.session_id = session_id
end

def assert_fail()
	assert_equal true, false
end

def help_api(controller)
	controller.create_menu "Brunch"
	menu = controller.read_menu().find { |m| m[:name] == "Brunch" }

	if menu then
		controller.create_item(menu[:id], "Eggs Benedict", 14, "The most delicious food of all time.")
		controller.create_item(menu[:id], "Awful Benedict", 8, "Why is this on the menu?")
		eggs = controller.read_item().find { |i| i[:name] == "Eggs Benedict" }
		assert_fail if not eggs

		controller.update_item(eggs[:id], menu[:id], "Eggs Benedict", 12, "The most delicious food of all time.") if eggs
		awful = controller.read_item().find { |i| i[:name] == "Awful Benedict" }
		assert_fail if not awful
		controller.delete_item(awful[:id])
	end

	controller.create_user("cam", "securepassword1337", 1, 2000)
	controller.create_user("ham", "baconpassword1337", 0, 1000)
	users = controller.read_user()
	if users then
		cam = users.find { |u| u[:name] == "cam" }
		ham = users.find { |u| u[:name] == "ham" }
		controller.update_user(cam[:id], "cam", "securepassword1337", 0, 42) if cam
		controller.delete_user(ham[:id]) if ham
	end
end

def reset_shell_pwd(controller)
	@controller.shell_pwd = @controller.controller_pwd
end

class PublicTests < MiniTest::Test
	def setup
		@controller = Controller.new
		@controller.db.transaction
	end

	def teardown
		@controller.db.rollback
	end

	def test_public_password_not_plaintext()
		as_admin(@controller)
		users = @controller.read_user
		users.each do |user|
			assert_equal -1, @controller.authenticate(user[:name], user[:password])
		end
	end

	def test_public_password_hash_and_salt()
		as_admin(@controller)
		@controller.create_user("PublicTestUser", "password", 0, 0)
		@controller.db.execute "SELECT Password, Salt FROM Users WHERE NAME=\"PublicTestUser\"" do |user|
			assert_equal user[0], Digest::SHA256.hexdigest("password" + user[1])
		end
	end

	def test_public_stored_xss()
		as_employee(@controller)
		@controller.create_menu "Brunch"
		menu = @controller.read_menu().find { |m| m[:name] == "Brunch" }
		assert_equal false, menu.nil?

		@controller.create_item(menu[:id], "Wholesome Benedict", 14, "Non-evil eggs benedict.")
		@controller.create_item(menu[:id], "Evil Benedict", 111, "<script>alert(0);</script>")
		evil = @controller.read_item().find { |i| i[:name] == "Evil Benedict" }
		eggs = @controller.read_item().find { |i| i[:name] == "Wholesome Benedict" }
		assert_fail if not evil
		assert_fail if not eggs
		assert_equal false, "<script>alert(0);</script>" == evil[:description]
		assert_equal "Non-evil eggs benedict.", eggs[:description]
	end

	def test_public_sql_injection()
		as_employee(@controller)
		@controller.create_menu "Brunch"
		menu = @controller.read_menu().find { |m| m[:name] == "Brunch" }
		assert_equal false, menu.nil?

		@controller.create_item(menu[:id], "Wholesome Benedict", 14, "Non-evil eggs benedict.")
		@controller.create_item(menu[:id], "Evil Benedict", 111, "\"); DELETE FROM Items;--")
		eggs = @controller.read_item().find { |i| i[:name] == "Wholesome Benedict" }
		assert_equal false, eggs.nil?

		users = @controller.read_user()
		ollie = users.find { |u| u[:name] == "ocamlollie" }
		@controller.update_user(ollie[:id], "ocamlollie", "\", Salary = 999999; --", 0, 50000)
		users = @controller.read_user()
		assert_equal false, users.nil?
		ollie = users.find { |u| u[:name] == "ocamlollie" }
		assert_equal false, ollie.nil?
		assert_equal 50000, ollie[:salary]
	end

	def test_public_delete_self()
		as_employee(@controller)
		users = @controller.read_user()
		assert_equal false, users.nil?
		ollie = users.find { |u| u[:name] == "ocamlollie" }
		assert_equal false, ollie.nil?

		@controller.delete_user(ollie[:id])
		users = @controller.read_user()
		ollie = users.find { |u| u[:name] == "ocamlollie" }
		assert_equal false, ollie.nil?
	end

	def test_public_delete_revoke_tokens()
		ollie_session = @controller.authenticate("ocamlollie", "ocamlollie")

		as_admin(@controller)
		users = @controller.read_user()
		assert_equal false, users.nil?

		ollie = users.find { |u| u[:name] == "ocamlollie" }
		assert_equal false, ollie.nil?

		@controller.delete_user(ollie[:id])
		users = @controller.read_user()
		ollie = users.find { |u| u[:name] == "ocamlollie" }
		assert_equal true, ollie.nil?
		assert_equal -1, @controller.authorize(ollie_session)
	end

	def test_public_employee_self_only()
		as_employee(@controller)
		users = @controller.read_user()
		ollie = users.find { |u| u[:name] == "ocamlollie" }

		assert_equal 1, users.length
		assert_equal false, ollie.nil?

		@controller.update_user(ollie[:id], "ocamlwallie", "", 1, 330)
		users = @controller.read_user()
		wallie = users.find { |u| u[:name] == "ocamlwallie" }
		assert_fail if not wallie
		assert_equal 50000, wallie[:salary]
		assert_equal 0, wallie[:admin]
	end

	def test_public_api_not_logged_in()
		help_api(@controller)

		brunch = @controller.read_menu().find { |m| m[:name] == "Brunch" }
		eggs = @controller.read_item().find { |i| i[:name] == "Eggs Benedict" }
		awful = @controller.read_item().find { |i| i[:name] == "Awful Benedict" }

		assert_equal true, brunch.nil?
		assert_equal true, eggs.nil?
		assert_equal true, awful.nil?

		users = @controller.read_user()
		if users then
			ollie = users.find { |u| u[:name] == "ocamlollie" }
			assert_equal true, ollie.nil?
		end

		as_admin(@controller)
		users = @controller.read_user()
		cam = users.find { |u| u[:name] == "cam" }
		ham = users.find { |u| u[:name] == "ham" }

		assert_equal true, cam.nil?
		assert_equal true, ham.nil?
	end

	def test_public_api_employee()
		as_employee(@controller)
		help_api(@controller)
		brunch = @controller.read_menu().find { |m| m[:name] == "Brunch" }
		eggs = @controller.read_item().find { |i| i[:name] == "Eggs Benedict" }
		awful = @controller.read_item().find { |i| i[:name] == "Awful Benedict" }

		assert_equal false, brunch.nil?
		assert_equal false, eggs.nil?
		assert_equal 12, eggs[:price]
		assert_equal true, awful.nil?

		lou = @controller.read_user().find { |u| u[:name] == "lambdalou" }
		ollie = @controller.read_user().find { |u| u[:name] == "ocamlollie" }

		assert_equal true, lou.nil?
		assert_equal false, ollie.nil?

		as_admin(@controller)
		cam = @controller.read_user().find { |u| u[:name] == "cam" }
		ham = @controller.read_user().find { |u| u[:name] == "ham" }

		assert_equal true, cam.nil?
		assert_equal true, ham.nil?
	end

	def test_public_api_admin()
		as_admin(@controller)
		help_api(@controller)
		brunch = @controller.read_menu().find { |m| m[:name] == "Brunch" }
		eggs = @controller.read_item().find { |i| i[:name] == "Eggs Benedict" }
		awful = @controller.read_item().find { |i| i[:name] == "Awful Benedict" }

		assert_equal false, brunch.nil?
		assert_equal false, eggs.nil?
		assert_equal 12, eggs[:price]
		assert_equal true, awful.nil?

		lou = @controller.read_user().find { |u| u[:name] == "lambdalou" }
		ollie = @controller.read_user().find { |u| u[:name] == "ocamlollie" }

		assert_equal false, lou.nil?
		assert_equal false, ollie.nil?

		cam = @controller.read_user().find { |u| u[:name] == "cam" }
		ham = @controller.read_user().find { |u| u[:name] == "ham" }

		assert_equal false, cam.nil?
		assert_equal 42, cam[:salary]
		assert_equal 0, cam[:admin]
		assert_equal true, ham.nil?
	end

	def test_public_dashboard()
		assert_equal false, @controller.guard(:dashboard)
		as_employee(@controller)
		assert_equal false, @controller.guard(:dashboard)
		as_admin(@controller)
		assert_equal true, @controller.guard(:dashboard)
	end

	def test_public_employee_pages()
		assert_equal false, @controller.guard(:menu)
		assert_equal false, @controller.guard(:users)
		as_employee(@controller)
		assert_equal true, @controller.guard(:menu)
		assert_equal true, @controller.guard(:users)
		as_admin(@controller)
		assert_equal true, @controller.guard(:menu)
		assert_equal true, @controller.guard(:users)
	end
end
