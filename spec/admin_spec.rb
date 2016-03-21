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
		menu=Menu.new [
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
		@pastOrder =Order.new  @customer, menuOrders, "deliveryAddress", pastDate, "specialInstructions", 12345
		@weekendOrder = Order.new  @customer, menuOrders, "deliveryAddress", weekendDate, "specialInstructions"
		@oldOrder=Order.new  @jones, menuOrders, "deliveryAddress", oldDate, "specialInstructions"
		@futureOrder=Order.new  @jones, menuOrders, "deliveryAddress", futureDate, "specialInstructions"
		@tomorrowOrder=Order.new  @customer, menuOrders, "deliveryAddress", tomorrowDate, "specialInstructions"
		@orders=[@order, @todayOrder, @pastOrder, @oldOrder, @futureOrder, @tomorrowOrder]
		@admin=Admin.new @orders, menu, @customers
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


	describe "#findCustomerOrders" do

		it "returns an array of orders for the customer" do
			@admin.findCustomerOrders(@jones).should eql [@oldOrder, @futureOrder]
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
end