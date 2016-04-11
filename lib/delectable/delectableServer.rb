# Ruby Delectable Server
require_relative 'food.rb'
require_relative 'menuItem.rb'
require_relative 'menu.rb'
require_relative 'order.rb'
require_relative 'customer.rb'
require_relative 'admin.rb'

require 'sinatra'
require 'json'
require 'date'
# get '/' do
# 	"Hello, World"	
# end

# get '/about' do
# 	"I love bad $% Problem"
# end


# get '/hello/:name' do
# 	"Hello there, #{params[:name]}"
# end

class DelectableServer
	attr_accessor :admin

	def initialize customers, orders, menu
		@admin=Admin.new customers, orders, menu
	end

	def getMenu
		
		@admin.menu
	end

end

bbqBeefBrisket=Food.new "BBQ Beef Brisket", [:beef,:meat]
coke=Food.new "Coke", [:drink]
pepsi=Food.new "Pepsi", [:drink]
bbqChicken=Food.new "BBQ Chicken", [:chicken,:meat]
lemonChicken=Food.new "Lemon Chicken", [:chicken,:meat]
salmon=Food.new "Smoked Salmon", [:fish,:pescatarian]
lasagna=Food.new "Lasagna", [:pasta]
@menu=Menu.new [
	(menuItem1=MenuItem.new bbqBeefBrisket, 10, 10),
	(menuItem2=MenuItem.new coke, 2, 6),
	(menuItem3=MenuItem.new pepsi, 2, 6),
	(menuItem4=MenuItem.new bbqChicken, 5, 10),
	(menuItem5=MenuItem.new lemonChicken, 6, 10), 
	(menuItem6=MenuItem.new salmon, 10, 10),
	(menuItem7=MenuItem.new lasagna, 5, 10)]
menuOrders=[[menuItem1, 15], [menuItem2, 10]]
deliveryDate=Time.new(2016, 06, 07, 3,30)
todayDate=Time.now
pastDate=Time.now - 5*86400
weekendDate=Time.new(2016,03,19, 3,30)
oldDate=Time.now - 30*8*86400
futureDate=Time.now + 5*86400
tomorrowDate=Time.now + 83000
@customer=Customer.new "CustomerFirstName", "CustomerLastName", "customerPhoneNumber", "Customer@email.com" 
@johnson=Customer.new "CustomerFirstName", "Johnson", "customerPhoneNumber", "Customer@email.com"
@jones=Customer.new "CustomerFirstName", "jones", "customerPhoneNumber", "jones@email.com"  
@customers=[@customer, @johnson, @jones]
@order=Order.new  @customer, menuOrders, "deliveryAddress", deliveryDate, "specialInstructions"
@copyOrder=Order.new  @customer, menuOrders, "deliveryAddress", deliveryDate, "specialInstructions"
@todayOrder=Order.new  @johnson, menuOrders, "deliveryAddress", todayDate, "specialInstructions"
@orderWithId =Order.new  @johnson, menuOrders, "deliveryAddress", deliveryDate, "specialInstructions", 12345
@pastOrder =Order.new  @customer, menuOrders, "deliveryAddress", pastDate, "specialInstructions", 12346
@weekendOrder = Order.new  @customer, menuOrders, "deliveryAddress", weekendDate, "specialInstructions", 12357
@oldOrder=Order.new  @jones, menuOrders, "deliveryAddress", oldDate, "specialInstructions"
@futureOrder=Order.new  @jones, menuOrders, "deliveryAddress", futureDate, "specialInstructions"
@tomorrowOrder=Order.new  @customer, menuOrders, "deliveryAddress", tomorrowDate, "specialInstructions"
@orders=[@order, @todayOrder, @pastOrder, @oldOrder, @futureOrder, @tomorrowOrder, @weekendOrder]
delect = DelectableServer.new(@orders, @menu, @customers)
set :port, 8080
set :environment, :production


get '/delectable/menu' do
	delect.admin.menu.to_JSON.to_json
end 

get '/delectable/menu/:id' do
	idValueString=params[:id].to_s
	delect.admin.menu.menuItems[idValueString.to_i].to_JSON.to_json
end

get '/delectable/order' do
	delect.admin.ordersToJSON.to_json
end

get '/delectable/order/:date' do
	date=DateTime.parse(params[:date])
	delect.admin.getOrdersDueThisDate(date).to_json
end