require 'spec_helper'

describe Admin do

	before :each do
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
		@pastOrder =Order.new  @customer, menuOrders, "deliveryAddress", pastDate, "specialInstructions", 12345
		@weekendOrder = Order.new  @customer, menuOrders, "deliveryAddress", weekendDate, "specialInstructions"
		@oldOrder=Order.new  @jones, menuOrders, "deliveryAddress", oldDate, "specialInstructions"
		@futureOrder=Order.new  @jones, menuOrders, "deliveryAddress", futureDate, "specialInstructions"
		@tomorrowOrder=Order.new  @customer, menuOrders, "deliveryAddress", tomorrowDate, "specialInstructions"
		@bbqOrder=Order.new @customer, [[menuItem1, 8],[menuItem4, 10]], "deliveryAddress", deliveryDate, "specialInstructions"
		@orders=[@order, @todayOrder, @pastOrder, @oldOrder, @futureOrder, @tomorrowOrder]
		@admin=Admin.new @orders, @menu, @customers
	end



	describe "#new" do

		it "returns a new Admin object" do
			@admin.should be_an_instance_of Admin
			puts "#{@customers[0].isMatch?("cust")}"
		end
	end


	describe "#searchCustomers" do

		it "returns an array of Customers that match the query" do
			@admin.searchCustomers("lastName").should eql [@customer]
			@admin.searchCustomers("jo").should eql [@johnson, @jones]
		end

		it "returns an empty array of Customers since the query does not match" do
			@admin.searchCustomers("gibberish").should eql []
		end

	end

	describe "#doesCustomerExist?" do

		it "returns true if the customer exists based on matching email" do
			@admin.doesCustomerExist?("jones@email.com").should eql true
		end

	end

	describe "#getCustomer" do

		it "returns a customer with the matching id" do
			@admin.getCustomer(123).should eql @jones
		end


		it "returns a nil when there is no matching id" do
			@admin.getCustomer(12345).should eql nil
		end

	end

	describe "#findCustomerOrders" do

		it "returns an array of orders for the customer" do
			@admin.findCustomerOrders(@jones).should eql [@oldOrder, @futureOrder]
		end	

	end


	describe "#addNewCustomer!" do

		it "adds a new customer object and adds it to the customer array" do
			newCustomer=Customer.new "Raman", "Walwyn-Venugopal", "258-725-7595", "raman@hawk.com"
			@admin.addNewCustomer!(newCustomer)
			@admin.customers.include?(newCustomer).should eql true
		end

		it "does not update the customer object if an existing customer with the email exists " do
			newCustomer=Customer.new "Raman", "Walwyn-Venugopal", "258-725-7595", "raman@hawk.com"
			@admin.addNewCustomer!(newCustomer)
			newNewCustomer=Customer.new "Stephen", "Walwyn-Venugopal", "258-725-7595", "raman@hawk.com"
			@admin.addNewCustomer!(newNewCustomer)
			@admin.customers.include?(newNewCustomer).should_not eql true
		end
	end


	describe "#getOrdersDueToday" do

		it "returns an array of orders that are due today" do
			@admin.getOrdersDueToday.should eql [@todayOrder]
		end

		it "does not return orders that are completed" do
			@admin.orders[1].completeOrder!
			@admin.getOrdersDueToday.should eql []
		end

	end

	describe "#getOrdersDueTomorrow" do

		it "returns an array of order that are due tomrrow" do
			@admin.getOrdersDueTomorrow.should eql [@tomorrowOrder]
		end

		it "does not return cancelled orders that are due tomorrow" do
			@admin.orders[5].cancelOrder!
			@admin.getOrdersDueTomorrow.should eql []
		end

	end

	describe "#getOrdersDueThisDate" do

		it "returns an array of orders that are due a specfific date" do
			@admin.getOrdersDueThisDate(Time.now + 5*86400).should eql [@futureOrder.to_JSON]
		end

	end

	describe "#addOrder!" do

		it "adds a new order to the array" do
			@admin.orders.include?(@bbqOrder).should eql false
			@admin.addOrder!(@bbqOrder)
			@admin.orders.include?(@bbqOrder).should eql true
		end

	end

	describe "#numberOfOrdersCopmleteWithinPastMonths" do

		it "returns 0 if no orders are compelted within the past month" do
			@admin.numberOfOrdersCopmleteWithinPastMonths(1).should eql 0
		end

		it "returns 1 for order copmleted within the past month" do
			@admin.orders[2].completeOrder!
			@admin.numberOfOrdersCopmleteWithinPastMonths(1).should eql 1
		end

		it "returns 2 for order completed within the past 9 months" do
			@admin.orders[2].completeOrder!
			@admin.orders[3].completeOrder!
			@admin.numberOfOrdersCopmleteWithinPastMonths(9).should eql 2
		end
	end

	describe "#earningsWithinPastMonths" do

		it "does not count past orders not completed in the past month" do
			@admin.earningsWithinPastMonths(1).should eql 0
		end

		it "counts the money made for the past order completed within the past month"  do
			@admin.orders[2].completeOrder!
			@admin.orders[2].calculateCost
			@admin.earningsWithinPastMonths(1).should eql 170
		end		

		it "counts the money made for orders completed within the past 9 months" do
			Order.changeSurcharge! 0
			@admin.orders[2].completeOrder!
			@admin.orders[2].calculateCost
			@admin.orders[3].completeOrder!
			@admin.orders[3].calculateCost
			@admin.earningsWithinPastMonths(9).should eql 340 
		end
	end

	describe "#changeSurcharge!" do

		it "changes the surcharge to $5.00" do
			@admin.changeSurcharge!(5)
			Order.surcharge.should eql 5
		end

		it "does not change the surchrge to a negative value" do
			surcharge=Order.surcharge
			@admin.changeSurcharge!(-5)
			Order.surcharge.should eql surcharge 
		end
	end

	describe "#addSurchargeDate!" do

		it "adds a date to the surcharge" do
			dateNow=Time.now
			@admin.addSurchargeDate!(dateNow)
			Order.surchargeDates.include?(dateNow).should eql true
			Order.removeAllSurchargeDates!
		end
	end

	describe "#removeSurchargeDate!" do

		it "removes surcharge date" do
			dateNow=Time.now
			@admin.addSurchargeDate!(dateNow)
			Order.surchargeDates.include?(dateNow).should eql true
			@admin.removeSurchargeDate!(0)
			Order.surchargeDates.include?(dateNow).should eql false
			Order.removeAllSurchargeDates!
		end
	end

	describe "#removeAllSurchargeDates!" do

		it "removes all surchargeDates" do
			dateNow=Time.now
			@admin.addSurchargeDate!(dateNow)
			Order.surchargeDates.include?(dateNow).should eql true
			@admin.removeAllSurchargeDates!
			Order.surchargeDates.should eql []
		end
	end


	describe "#ordersToJSON" do

		it "Converts all orders into JSON Object format" do
			@oneOrderAdmin=Admin.new [@pastOrder], @menu, @customers
			jsonObject={}
			jsonObject[:id]=12345
			jsonObject[:order_date]=@pastOrder.orderDate
			jsonObject[:deliveryDate]=@pastOrder.deliveryDate
			jsonObject[:amount]=@pastOrder.finalCost
			jsonObject[:surcharge]=@pastOrder.orderSurcharge
			jsonObject[:status]=@pastOrder.order_status
			jsonObject[:ordered_by]=@pastOrder.customer.email
			@oneOrderAdmin.ordersToJSON.should eql [jsonObject]
		end
	end

	describe "#customersToJSON" do

		it "Converts all customers into JSON Object Format" do
			@oneCustomerAdmin=Admin.new [@pastOrder], @menu, [@jones]
			jsonObject={}
			jsonObject[:id]=123
			jsonObject[:name]="jones"
			jsonObject[:email]="jones@email.com"
			jsonObject[:phone]="customerPhoneNumber"
			@oneCustomerAdmin.customersToJSON.should eql [jsonObject]
		end
	end
end