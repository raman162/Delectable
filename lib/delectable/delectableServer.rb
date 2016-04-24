# Ruby Delectable Server
require_relative 'food.rb'
require_relative 'menuItem.rb'
require_relative 'menu.rb'
require_relative 'order.rb'
require_relative 'customer.rb'
require_relative 'admin.rb'
require_relative 'report.rb'

require 'sinatra'
require 'json'
require 'date'

class DelectableServer
	attr_accessor :admin, :reports, :customers, :orders, :menu

	def initialize orders, menu, customers, reports
		@reports=reports
		@customers=customers
		@orders=orders
		@menu=menu
		@admin=Admin.new 
	end

	def createOrder(customer, deliveryAddress, deliveryDate, specialInstructions, order_details)
		newOrder = Order.new(customer, [], deliveryAddress, deliveryDate, specialInstructions)
		menuItems=self.getMenuItems(order_details)
		originalLength=menuItems.length
		menuItems.each do |menuItem|
			newOrder.addItem!(menuItem[0], menuItem[1])
		end
		if newOrder.itemsInOrder.length == originalLength
			self.addOrder!(newOrder)
			newOrder
		else
			return false
		end
	end	

	def searchCustomers(query)
		matchingCustomers=[]
		@customers.each do |thisCustomer|
			matchingCustomers << thisCustomer if thisCustomer.isMatch?(query)
		end
		matchingCustomers
	end

	def doesCustomerExist?(email)
		matchingCustomers=self.searchCustomers(email)
		if matchingCustomers.length > 0
			true
		else
			false
		end
	end

	def getCustomer(id)
		customerMatch=nil
		@customers.each do |customer|
			customerMatch=customer if customer.id == id
		end
		customerMatch
	end

	def findCustomerOrders(customer)
		customerOrders=[]
		customerEmail=customer.email
		@orders.each do |order|
			customerOrders << order if order.isMatch?(customerEmail)
		end
		customerOrders
	end

	def addNewCustomer!(newCustomer)
		@customers << newCustomer unless doesCustomerExist?(newCustomer.email)
	end

	def createCustomer(name, email, phone)
		if self.doesCustomerExist?(email)
			matchingCustomers=self.searchCustomers(email)
			matchingCustomers[0]
		else
			newCustomer = Customer.new(name, phone, email)
			addNewCustomer!(newCustomer) 
			newCustomer
		end
	end

	def getOrder(id)
		orderMatch=false
		@orders.each do |order|
			orderMatch=order if order.id==id
		end
		orderMatch
	end

	def cancelOrder!(id)
		@orders.each do |order|
			order.cancelOrder! if order.id==id
		end
	end

	def getOrdersDueToday
		ordersDueToday=[]
		@orders.each do |order|
			ordersDueToday << order if order.dueToday?
		end
		ordersDueToday
	end

	def getOrdersDueTomorrow
		ordersDueTomorrow=[] 
		@orders.each do |order|
			ordersDueTomorrow << order if order.dueTomorrow?
		end
		ordersDueTomorrow
	end

	def getOrdersDueThisDate(date)
		ordersDue=[]
		@orders.each do |order|
			ordersDue << order.to_JSON if order.dueThisDate?(date)
		end
		ordersDue
	end

	def addOrder!(order)
		@orders << order
	end

	def getMenuItems(order_details)
		itemsThatExist=[]
		order_details.each do |order_detail|
			if self.menu.doesMenuItemExist?(order_detail["id"])
				id=order_detail["id"].to_i
				itemsThatExist << [self.menu.getMenuItem(id), order_detail["count"].to_i]
			end
		end
		itemsThatExist
	end

	def getCategories(categoriesJson)
		categories=[]
		categoriesJson.each do |catJson|
			categories << catJson["name"].gsub(/\s+/, "_").downcase.to_sym
		end
		categories
	end

	def getCustomerOrdersJson(id)
		customer=self.getCustomer(id)
		customerOrders=self.findCustomerOrders(customer)
		jsonOrders=[]
		customerOrders.each do |order|
			jsonOrders << order.to_ShortJson
		end
		jsonOrders
	end

	def generateReports!
		todayReport=OrderReport.new(self.orders, "Orders to deliver today")
		jsonReport=todayReport.generateTodayOrderReport
		tomorrowReport=OrderReport.new(self.orders, "Orders to deliver tomrrow")
		jsonReport=tomorrowReport.generateTomorrowOrderReport
		orderReport=OrderReport.new(self.orders, "Orders delivery report")
		# jsonReport=orderReport.generateReport
		revenueReport=RevenueReport.new(self.orders, "Revenue report")
		@reports << todayReport unless @reports.include?(todayReport)
		@reports << tomorrowReport unless @reports.include?(tomorrowReport)
		@reports << orderReport unless @reports.include?(orderReport)
		@reports << revenueReport unless @reports.include?(revenueReport)
	end

	def getJsonReports
		jsonObject=[]
		@reports.each do |report|
			jsonObject << report.to_JSON
		end
		jsonObject
	end

	def getReport(id)
		reportMatch=false
		@reports.each do |report|
			reportMatch=report if report.id==id
		end
		reportMatch
	end	

	def ordersToJSON
		orderArray=[]
		@orders.each do |order|
			orderArray << order.to_JSON
		end
		orderArray
	end

	def customersToJSON
		customerArray=[]
		@customers.each do |customer|
			customerArray << customer.to_JSON
		end
		customerArray
	end
end


# #TEST DATA
# bbqBeefBrisket=Food.new "BBQ Beef Brisket", [:beef,:meat]
# coke=Food.new "Coke", [:drink]
# pepsi=Food.new "Pepsi", [:drink]
# bbqChicken=Food.new "BBQ Chicken", [:chicken,:meat]
# lemonChicken=Food.new "Lemon Chicken", [:chicken,:meat]
# salmon=Food.new "Smoked Salmon", [:fish,:pescatarian]
# lasagna=Food.new "Lasagna", [:pasta]
# @menu=Menu.new [
# 	(menuItem1=MenuItem.new bbqBeefBrisket, 10, 10, 123),
# 	(menuItem2=MenuItem.new coke, 2, 6, 124),
# 	(menuItem3=MenuItem.new pepsi, 2, 6, 125),
# 	(menuItem4=MenuItem.new bbqChicken, 5, 10, 126),
# 	(menuItem5=MenuItem.new lemonChicken, 6, 10, 127), 
# 	(menuItem6=MenuItem.new salmon, 10, 10, 128),
# 	(menuItem7=MenuItem.new lasagna, 5, 10,129)]
# menuOrders=[[menuItem1, 15], [menuItem2, 10]]
# deliveryDate=Time.new(2016, 06, 07, 3,30)
# todayDate=Time.now
# pastDate=Time.now - 5*86400
# weekendDate=Time.new(2016,03,19, 3,30)
# oldDate=Time.now - 30*8*86400
# futureDate=Time.now + 5*86400
# tomorrowDate=Time.now + 83000
# @customer=Customer.new  "CustomerLastName", "customerPhoneNumber", "Customer@email.com" 
# @johnson=Customer.new  "Johnson", "customerPhoneNumber", "Customer@email.com"
# @jones=Customer.new  "jones", "customerPhoneNumber", "jones@email.com", 123  
# @customers=[@customer, @johnson, @jones]
# @order=Order.new  @customer, menuOrders, "deliveryAddress", deliveryDate, "specialInstructions"
# @copyOrder=Order.new  @customer, menuOrders, "deliveryAddress", deliveryDate, "specialInstructions"
# @todayOrder=Order.new  @johnson, menuOrders, "deliveryAddress", todayDate, "specialInstructions"
# @orderWithId =Order.new  @johnson, menuOrders, "deliveryAddress", deliveryDate, "specialInstructions", 12345
# @pastOrder =Order.new  @customer, menuOrders, "deliveryAddress", pastDate, "specialInstructions", 12346
# @weekendOrder = Order.new  @customer, menuOrders, "deliveryAddress", weekendDate, "specialInstructions", 12357
# @oldOrder=Order.new  @jones, menuOrders, "deliveryAddress", oldDate, "specialInstructions"
# @futureOrder=Order.new  @jones, menuOrders, "deliveryAddress", futureDate, "specialInstructions"
# @tomorrowOrder=Order.new  @customer, menuOrders, "deliveryAddress", tomorrowDate, "specialInstructions"
# @orders=[@order, @todayOrder, @pastOrder, @oldOrder, @futureOrder, @tomorrowOrder, @weekendOrder]

#IF YOU USE THE TEST DATA BE SURE TO USE @orders, @menu, AND @customers
# delect = DelectableServer.new(@orders, @menu, @customers, [OrderReport.new(@orders, "TestReport", false, false, 1234)])

#THE REAL RUNNING SYSTEM
@menu=Menu.new
@orders=[]
@customers=[]
@reports=[]
delect=DelectableServer.new(@orders, @menu, @customers, @reports)
set :port, 8080
set :environment, :production



#MENU
get '/delectable/menu' do
	delect.menu.to_JSON.to_json
end 

get '/delectable/menu/:id' do
	idValueString=params[:id].to_s
	delect.menu.getMenuItem(idValueString.to_i).to_JSON.to_json
end



#ORDER
get '/delectable/order' do
	if params['date']
		date=Time.parse(params['date'])
		delect.getOrdersDueThisDate(date).to_json
	else
		delect.ordersToJSON.to_json
	end
end


get '/delectable/order/:id' do
	id=params[:id].to_i
	delect.getOrder(id).to_JSON.to_json
end

put '/delectable/order' do
	@params=JSON.parse(request.env["rack.input"].read)
	if @params
		customerName=@params["personal_info"]["name"]
		customerEmail=@params["personal_info"]["email"]
		customerPhone=@params["personal_info"]["phone"]
		newCustomer=delect.createCustomer(customerName, customerEmail, customerPhone)
		deliveryAddress=@params["delivery_address"]		
		deliveryDate=Time.parse(@params["delivery_date"])
		specialInstructions=@params["note"]
		orderDetails=@params["order_detail"]
		deliveryAddress.to_json
		newOrder=delect.createOrder(newCustomer, deliveryAddress, deliveryDate,specialInstructions,orderDetails)
		if newOrder
			jsonObject={}
			jsonObject[:id]=newOrder.id
			jsonObject[:cancel_url]="/order/cancel/"+newOrder.id.to_s
			jsonObject
		else
			status 400
		end
	else 
		status 400
	end
end

post '/delectable/order/cancel/:id' do
	delect.cancelOrder!(params[:id].to_i)
	order=delect.getOrder(params[:id].to_i)
	if order.order_status != 0
		status 400
	else
		status 200
	end
end




#CUSTOMER
get '/delectable/customer' do
	if params['key']
		query=params['key']
		matchingCustomers=delect.searchCustomers(query)
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
		delect.customersToJSON.to_json
	end
end

get '/delectable/customer/:id' do
	id=params[:id].to_i
	jsonObject=delect.getCustomer(id).to_JSON
	jsonObject[:orders]=delect.getCustomerOrdersJson(id)
	jsonObject.to_json
end

#REPORT
get '/delectable/report' do
	delect.generateReports!
	reports=delect.getJsonReports
	reports.to_json
end


get "/delectable/report/:id" do
	id=params[:id].to_i
	report=delect.getReport(id)
	if params['start_date']
		startDate=Time.parse(params['start_date'])
		oldStartDate=report.startDate
		report.changeStartDate!(startDate)
	end
	if params['end_date']
		endDate=Time.parse(params['end_date'])
		oldEndDate=report.endDate
		report.changeEndDate!(endDate)
	end
	report.orders=delect.orders
	jsonObject=report.generateReport
	if(oldStartDate) then report.changeStartDate!(oldStartDate) end
	if(oldEndDate) then report.changeEndDate!(oldEndDate) end
	jsonObject.to_json
	
end	

#ADMIN
put '/delectable/admin/menu' do
	@params=JSON.parse(request.env["rack.input"].read)
	if @params
		foodName=@params["name"]
		categoriesJson=@params["categories"]
		categories=delect.getCategories(categoriesJson)
		newFood=Food.new(foodName, categories)
		pricePerPerson=@params["price_per_person"]
		minOrder=@params["minimum_order"]
		newMenuItem=MenuItem.new(newFood, pricePerPerson, minOrder)
		delect.admin.addItemToMenu!(delect.menu, newMenuItem)
	end
end

post '/delectable/admin/menu/:id' do
	@params=JSON.parse(request.env["rack.input"].read)
	delect.menu.menuItems[@params["id"]].price_per_person=@params["price_per_person"]
end

get '/delectable/admin/surcharge' do
	jsonObject={}
	if Order.surcharge 
		jsonObject[:surcharge]=Order.surcharge
		jsonObject.to_json
	else
		'This is not working Sir'
	end
end

post '/delectable/admin/surcharge' do
	@params=JSON.parse(request.env["rack.input"].read)
	delect.admin.changeSurcharge!(@params['surcharge'])
end


post '/delectable/admin/delivery/:id' do
	delect.admin.changeOrderStatusToDelivered!(params[:id].to_i)
	jsonObject={}
	jsonObject[:id]=params[:id].to_i
	jsonObject.to_json
end
