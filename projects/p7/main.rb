require "sinatra"
require "json"
require "./controller"

#
# CONFIGURATION
#

enable :sessions

def is_grace
	/^grace\d+\.umd\.edu$/ =~ `hostname`
end

def port_by_did
	(`whoami`.hash.abs) % 48128 + 1024
end

configure do
	if is_grace then
		set :port, port_by_did
	else
		set :port, 8080
	end
end

def initialize
	@controller = Controller.new
	@success = { "success" => true }.to_json
end

#
# PAGES
#

not_found do
	status 404
	"Sorry, couldn't find that page."
end

before "/*" do
	session[:id] = -1 if !session[:id]
	@controller.session_id = session[:id]
end

get "/" do
	erb :"index"
end

get "/menu" do
	erb :"menu"
end

get "/about" do
	erb :"about"
end

get "/login" do
	erb :"login"
end

get "/logout" do
	@controller.delete_session(session[:id]) if session[:id]
	session[:id] = -1
	redirect to("/")
end

get "/admin/" do
	redirect to("/admin/dashboard")
end

get "/admin/dashboard" do
	redirect "/login" unless @controller.guard(:dashboard)
	erb :"admin/dashboard",
		{ :locals => { :admin => @controller.admin?(session[:id]) }}
end

get "/admin/menu" do
	redirect "/login" unless @controller.guard(:menu)
	erb :"admin/menu",
		{ :locals => { :admin => @controller.admin?(session[:id]) }}
end

get "/admin/users" do
	redirect "/login" unless @controller.guard(:users)
	erb :"admin/users",
		{ :locals => { :admin => @controller.admin?(session[:id]) }}
end

#
# API
#

before "/api/*" do
	content_type :json
end

get "/api/item" do
	{ :item => @controller.read_item.select { |i| i[:menu].to_s == params["menu"] }}.to_json
end

post "/api/item" do
        @controller.update_item(params["id"], params["menu"], params["name"], params["price"], params["description"])
        @success
end

put "/api/item" do
        @controller.create_item(params["menu"], params["name"], params["price"], params["description"])
	@success
end

delete "/api/item" do
	@controller.delete_item(params["id"])
	@success
end

put "/api/menu" do
	@controller.create_menu(params["name"])
	@success
end

get "/api/menu" do
	{ :menu => @controller.read_menu }.to_json
end

post "/api/menu" do
	@controller.update_menu(params["id"], params["name"])
	@success
end

delete "/api/menu" do
	@controller.delete_menu(params["id"])
	@success
end

get "/api/collate_menus" do
	@controller.collate_menus.to_json
end

put "/api/user" do
	@controller.create_user(params["name"], params["password"], params["admin"], params["salary"])
	@success
end

get "/api/user" do
	@controller.read_user.to_json
end

post "/api/user" do
	@controller.update_user(params["id"], params["name"], params["password"], params["admin"], params["salary"])
	@success
end

delete "/api/user" do
	if @controller.delete_user(params["id"]) then
		return 1.to_json
	else
		return 0.to_json
	end
end

post "/api/authenticate" do
	session_id = @controller.authenticate(params["name"], params["password"])
	session[:id] = session_id

	if session_id < 0 then
		return 0.to_json
	elsif not @controller.admin?(session_id) then
		return 1.to_json
	else
		return 2.to_json
	end
end

post "/api/terminal" do
	@controller.shell(params["command"])
end
