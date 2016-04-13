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

	def createOrder(customer, deliveryAddress, deliveryDate, specialInstructions, order_details)
		newOrder = Order.new(customer, [], deliveryAddress, deliveryDate, specialInstructions)
		menuItems=self.getMenuItems(order_details)
		menuItems.each do |menuItem|
			newOrder.addItem!(menuItem[0], menuItem[1])
		end
		@admin.addOrder!(newOrder)
		newOrder
	end	

	def createCustomer(name, email, phone)
		if @admin.doesCustomerExist?(email)
			false
		else
			newCustomer = Customer.new(name, phone, email)
			@admin.addNewCustomer!(newCustomer)
			newCustomer
		end
	end

	def getMenuItems(order_details)
		itemsThatExist=[]
		order_details.each do |order_detail|
			if @admin.menu.doesMenuItemExist?(order_detail["id"])
				itemsThatExist << [@admin.menu.getMenuItem(order_detail["id"]), order_detail["count"]]
			end
		end
		itemsThatExist
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
	(menuItem1=MenuItem.new bbqBeefBrisket, 10, 10, 123),
	(menuItem2=MenuItem.new coke, 2, 6, 124),
	(menuItem3=MenuItem.new pepsi, 2, 6, 125),
	(menuItem4=MenuItem.new bbqChicken, 5, 10, 126),
	(menuItem5=MenuItem.new lemonChicken, 6, 10, 127), 
	(menuItem6=MenuItem.new salmon, 10, 10, 128),
	(menuItem7=MenuItem.new lasagna, 5, 10,129)]
menuOrders=[[menuItem1, 15], [menuItem2, 10]]
deliveryDate=Time.new(2016, 06, 07, 3,30)
todayDate=Time.now
pastDate=Time.now - 5*86400
weekendDate=Time.new(2016,03,19, 3,30)
oldDate=Time.now - 30*8*86400
futureDate=Time.now + 5*86400
tomorrowDate=Time.now + 83000
@customer=Customer.new  "CustomerLastName", "customerPhoneNumber", "Customer@email.com" 
@johnson=Customer.new  "Johnson", "customerPhoneNumber", "Customer@email.com"
@jones=Customer.new  "jones", "customerPhoneNumber", "jones@email.com", 123  
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



#MENU
get '/delectable/menu' do
	delect.admin.menu.to_JSON.to_json
end 

get '/delectable/menu/:id' do
	idValueString=params[:id].to_s
	delect.admin.menu.menuItems[idValueString.to_i].to_JSON.to_json
end



#ORDER
get '/delectable/order' do
	if params['date']
		date=DateTime.parse(params['date'])
		delect.admin.getOrdersDueThisDate(date).to_json
	else
		delect.admin.ordersToJSON.to_json
	end
end


get '/delectable/order/:id' do
	id=params[:id].to_i
	delect.admin.getOrder(id).to_JSON.to_json
end

put '/delectable/order' do
	return_message={}
	@params=JSON.parse(request.env["rack.input"].read)
	if @params
		customerName=@params["personal_info"]["name"]
		customerEmail=@params["personal_info"]["email"]
		customerPhone=@params["personal_info"]["phone"]
		newCustomer=delect.createCustomer(customerName, customerEmail, customerPhone)
		deliveryAddress=@params["delivery_address"]		
		deliveryDate=DateTime.parse(@params["delivery_date"])
		specialInstructions=@params["note"]
		orderDetails=@params["order_detail"]
		deliveryAddress.to_json
		newOrder=delect.createOrder(newCustomer, deliveryAddress, deliveryDate,specialInstructions,orderDetails)
		jsonObject={}
		jsonObject[:id]=newOrder.id
		jsonObject[:cancel_url]="/order/cancel/"+newOrder.id.to_s
		jsonObject
	else 
		':('
	end
end

post '/delectable/order/cancel/:id' do
	delect.admin.cancelOrder!(params[:id].to_i)
	jsonObject={}
	jsonObject[:id]=params[:id].to_i
	jsonObject.to_json
end




#CUSTOMER
get '/delectable/customer' do
	if params['key']
		query=params['key']
		matchingCustomers=delect.admin.searchCustomers(query)
		jsonReturn=[]
		if matchingCustomers
			matchingCustomers.each do |customer|
				jsonReturn << customer.to_JSON
			end
			jsonReturn.to_json
		else
			'Something is wrong'
		end		
	else
		delect.admin.customersToJSON.to_json
	end
end

get '/delectable/customer/:id' do
	id=params[:id].to_i
	delect.admin.getCustomer(id).to_JSON.to_json
	# id.to_i
end


get '/
delectable/admin/surcharge' do
	jsonObject={}
	if Order.surcharge 
		jsonObject[:surcharge]=Order.surcharge
		jsonObject.to_json
	else
		'This is not working Sir'
	end
end

