require 'spec_helper'

describe DelectableServer do
	
	before :each do
		# TEST DATA
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

		# IF YOU USE THE TEST DATA BE SURE TO USE @orders, @menu, AND @customers
		@delect = DelectableServer.new(@orders, @menu, @customers, [OrderReport.new(@orders, "TestReport",false, false)])

	end

	describe "#new" do

		it "returns a new Server Object" do
			@delect.should be_an_instance_of DelectableServer
		end
	end

	describe "#searchCustomers" do

		it "returns an array of matching Customer objects" do
			@delect.searchCustomers("lastName").should eql [@customer]
			@delect.searchCustomers("jo").should eql [@johnson, @jones]
		end
	end


	describe "#doesCustomerExist?" do

		it "returns true if the customer exists based on matching email" do
			@delect.doesCustomerExist?("jones@email.com").should eql true
		end

	end

	describe "#getCustomer" do

		it "returns a customer with the matching id" do
			@delect.getCustomer(123).should eql @jones
		end


		it "returns a nil when there is no matching id" do
			@delect.getCustomer(12345).should eql nil
		end

	end

	describe "#findCustomerOrders" do

		it "returns an array of orders for the customer" do
			@delect.findCustomerOrders(@jones).should eql [@oldOrder, @futureOrder]
		end	

	end

	describe "#addNewCustomer!" do

		it "adds a new customer object and adds it to the customer array" do
			newCustomer=Customer.new "Raman", "Walwyn-Venugopal", "258-725-7595", "raman@hawk.com"
			@delect.addNewCustomer!(newCustomer)
			@delect.customers.include?(newCustomer).should eql true
		end

		it "does not update the customer object if an existing customer with the email exists " do
			newCustomer=Customer.new "Raman", "Walwyn-Venugopal", "258-725-7595", "raman@hawk.com"
			@delect.addNewCustomer!(newCustomer)
			newNewCustomer=Customer.new "Stephen", "Walwyn-Venugopal", "258-725-7595", "raman@hawk.com"
			@delect.addNewCustomer!(newNewCustomer)
			@delect.customers.include?(newNewCustomer).should_not eql true
		end
	end

	describe "#createCustomer" do

		it "creates a new customer if the current customer does not exist in the system" do
			@delect.createCustomer("raman", "raman@hawk.com", "3124591234")
			@delect.doesCustomerExist?("raman@hawk.com").should eql true
		end

		it "does not create a duplicate customer if the current customer ecists in the system" do
			@delect.createCustomer("jone", "jones@email.com", 31244591234)
			matchingCusotmers=@delect.searchCustomers("jones@email.com")
			matchingCusotmers.length.should eql 1
		end
	end

		describe "#getOrdersDueToday" do

		it "returns an array of orders that are due today" do
			@delect.getOrdersDueToday.should eql [@todayOrder]
		end

		it "does not return orders that are completed" do
			@delect.orders[1].completeOrder!
			@delect.getOrdersDueToday.should eql []
		end

	end

	describe "#getOrdersDueTomorrow" do

		it "returns an array of order that are due tomrrow" do
			@delect.getOrdersDueTomorrow.should eql [@tomorrowOrder]
		end

		it "does not return cancelled orders that are due tomorrow" do
			@delect.orders[5].cancelOrder!
			@delect.getOrdersDueTomorrow.should eql []
		end

	end

	describe "#getOrdersDueThisDate" do

		it "returns an array of orders that are due a specfific date" do
			@delect.getOrdersDueThisDate(Time.now + 5*86400).should eql [@futureOrder.to_JSON]
		end

	end

	describe "#getOrder" do

		it "returns the order object" do
			@delect.getOrder(12346).should eql @pastOrder
		end

		it "returns false if the order object does not exist" do
			@delect.getOrder(1).should eql false
		end

	end

	describe "#addOrder!" do

		it "adds a new order to the array" do
			@delect.orders.include?(@bbqOrder).should eql false
			@delect.addOrder!(@bbqOrder)
			@delect.orders.include?(@bbqOrder).should eql true
		end

	end

	describe "#ordersToJSON" do

		it "Converts all orders into JSON Object format" do
			@oneOrderDelectableServer=DelectableServer.new [@pastOrder], @menu, @customers, []
			jsonObject={}
			jsonObject[:id]=12346
			jsonObject[:order_date]=@pastOrder.orderDate
			jsonObject[:deliveryDate]=@pastOrder.deliveryDate
			jsonObject[:amount]=@pastOrder.finalCost
			jsonObject[:surcharge]=@pastOrder.orderSurcharge
			jsonObject[:status]=@pastOrder.getJsonOrderStatus
			jsonObject[:ordered_by]=@pastOrder.customer.email
			jsonObject[:order_detail]=@pastOrder.getJsonOrderDetail
			@oneOrderDelectableServer.ordersToJSON.should eql [jsonObject]
		end
	end

	describe "#customersToJSON" do

		it "Converts all customers into JSON Object Format" do
			@oneCustomerDelectableServer=DelectableServer.new [@pastOrder], @menu, [@jones], []
			jsonObject={}
			jsonObject[:id]=123
			jsonObject[:name]="jones"
			jsonObject[:email]="jones@email.com"
			jsonObject[:phone]="customerPhoneNumber"
			@oneCustomerDelectableServer.customersToJSON.should eql [jsonObject]
		end
	end


end