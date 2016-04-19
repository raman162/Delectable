require 'spec_helper'

describe Order do

	before :each do
		bbqBeefBrisket=Food.new "BBQ Beef Brisket", [:beef,:meat]
		coke=Food.new "Coke", [:drink]
		pepsi=Food.new "Pepsi", [:drink]
		bbqChicken=Food.new "BBQ Chicken", [:chicken,:meat]
		lemonChicken=Food.new "Lemon Chicken", [:chicken,:meat]
		salmon=Food.new "Smoked Salmon", [:fish,:pescatarian]
		@menuItems=[
			(@menuItem1=MenuItem.new bbqBeefBrisket, 10, 10, 123),
			(@menuItem2=MenuItem.new coke, 2, 6, 124),
			(@menuItem3=MenuItem.new pepsi, 2, 6),
			(@menuItem4=MenuItem.new bbqChicken, 5, 10),
			(@menuItem5=MenuItem.new lemonChicken, 6, 10), 
			(@menuItem6=MenuItem.new salmon, 10, 10)]
		menuOrders=[[@menuItem1, 15], [@menuItem2, 10]]
		deliveryDate=Time.new(2016, 06, 07, 3,30)
		todayDate=Time.now
		pastDate=Time.now - 5*86400
		weekendDate=Time.new(2016,03,19, 3,30)
		oldDate=Time.now - 30*8*86400
		futureDate=Time.now + 5*86400
		eightDayDate=Time.now + 8*86400
		tomorrowDate=Time.now + 83000
		customer=Customer.new "CustomerLastName", "customerPhoneNumber", "Customer@email.com" 
		@order=Order.new  customer , menuOrders, "deliveryAddress", deliveryDate, "specialInstructions"
		@copyOrder=Order.new  customer, menuOrders, "deliveryAddress", deliveryDate, "specialInstructions"
		@todayOrder=Order.new  customer, menuOrders, "deliveryAddress", todayDate, "specialInstructions"
		@orderWithId =Order.new  customer, menuOrders, "deliveryAddress", deliveryDate, "specialInstructions", 12345
		@pastOrder =Order.new  customer, menuOrders, "deliveryAddress", pastDate, "specialInstructions", 12345
		@oldOrder=Order.new  customer, menuOrders, "deliveryAddress", oldDate, "specialInstructions"
		@futureOrder=Order.new  customer, menuOrders, "deliveryAddress", futureDate, "specialInstructions"
		@dueInEightdayOrder=Order.new  customer, menuOrders, "deliveryAddress", eightDayDate, "specialInstructions"
		@tomorrowOrder=Order.new  customer, menuOrders, "deliveryAddress", tomorrowDate, "specialInstructions"
		@emptyOrder=Order.new customer, [], "delivery", tomorrowDate, "specialInstructions"
		Order.changeSurcharge! 5
		@weekendOrder = Order.new  customer, menuOrders, "deliveryAddress", weekendDate, "specialInstructions"
		Order.changeSurcharge! 0
	end


	describe "#new" do

		it "returns a new Order Object" do
			@order.should be_an_instance_of Order
		end


		it "return a new Order Object when given an id" do
			@orderWithId.should be_an_instance_of Order
		end

		it "returns a new ORder object when given an empty array of menuItem" do
			@emptyOrder.should be_an_instance_of Order
		end
	end


	describe "#addItem!" do
		
		it "adds an item to the order" do
			@order.addItem!(@menuItem3, 10)
			@order.itemsInOrder.include?([@menuItem3, 10]).should eql true
		end

		it "won't add an item if the quantity is not enough" do
			@order.addItem!(@menuItem2, 5)
			@order.itemsInOrder.include?([@menuItem2, 5]).should_not eql true
		end
	end

	describe "#removeItem!" do

		it "removes the second item from the order" do
			@order.removeItem!(1)
			@order.itemsInOrder.include?([@menuItem2, 10]).should_not eql true
		end

		it "does nothing if location is invalid" do
			@order.removeItem!(-1)
			@order.itemsInOrder.should eql @copyOrder.itemsInOrder
			@order.removeItem!(5)
			@order.itemsInOrder.should eql @copyOrder.itemsInOrder
		end
	end

	describe "#cancelOrder!" do

		it "cancels the order" do
			@order.cancelOrder!
			@order.order_status.should eql 0
		end

		it "does not cancel the order since it's today" do
			@todayOrder.cancelOrder!
			@order.order_status.should eql 1
		end

	end

	

	describe "#completeOrder!" do

		it "change Order Status to complete for order due today" do
			@todayOrder.completeOrder!
			@todayOrder.order_status.should eql 2
		end

		it "change Order Status to complete for orders due in the past" do
			@pastOrder.completeOrder!
			@pastOrder.order_status.should eql 2
		end

		it "does not allow orders in the future to be complete" do
			@order.completeOrder!
			@order.order_status.should eql 1
		end

	end

	describe "#dueToday?" do

		it "returns false since order is not due today" do
			@order.dueToday?.should eql false
		end

		it "retruns true if order is due today" do
			@todayOrder.dueToday?.should eql true
		end
	end

	describe "#dueInThePast?" do

		it "returns true if order is in the past" do
			@pastOrder.dueInThePast?.should eql true
		end

		it "return false for future order" do
			@order.dueInThePast?.should eql false
		end
	end

	describe "#isDueThisDate?" do

		it "returns true for orders due the specefic date" do
			@futureOrder.dueThisDate?(Time.now + 5*86400).should eql true
		end

	end

	describe "#dueWithinTheRange?" do

		it "returns true for orders due within a specefic range of dates" do
			@todayOrder.dueWithinTheRange?(Time.now-86400, Time.now+86400).should eql true
		end

		it "returns false for order not in range of dates" do
			@todayOrder.dueWithinTheRange?(Time.now-4*86400, Time.now-86400).should eql false
		end

		it "returns false for when given end date that was yesterday and no start date" do
			@todayOrder.dueWithinTheRange?(false,Time.now-86400).should eql false
		end

		it "returns true for when given start date in past and false end date" do
			@todayOrder.dueWithinTheRange?(Time.now-86400, false).should eql true
		end
	end

	describe "#dueInTheFuture?" do

		it "returns true if order is due in the future" do
			@order.dueInTheFuture?.should eql true
		end

		it "returns false if order is due today" do
			@todayOrder.dueInTheFuture?.should eql false
		end

		it "return false if order is due in the past" do
			@pastOrder.dueInTheFuture?.should eql false
		end
	end

	describe "#dueTomorrow?" do

		it "returns true if the order is due Tomorrow" do
			@tomorrowOrder.dueTomorrow?.should eql true
		end
	end

	describe "dueWithinDays?" do

		it "returns true if the order is due within 7 days" do
			@futureOrder.dueWithinDays?(7).should eql true
		end

		it "returns false if the order is ahead of 8 days" do
			@dueInEightdayOrder.dueWithinDays?(7).should eql false
		end

	end

	describe "#completeWithinPastDays?" do

		it "returns false if the order is pending in the past" do
			@pastOrder.completeWithinPastDays?(7).should eql false
		end

		it "returns true if order is completed within 7 days" do
			@pastOrder.completeOrder!
			@pastOrder.completeWithinPastDays?(7).should eql true
		end

	end

	describe "#completeWithinPastMonths?" do

		
		it "returns false for orders not complete within the past month" do
			@pastOrder.completeWithinPastMonths?(1).should eql false
		end

		it "returns true for orders compelete within the past month" do
			@pastOrder.completeOrder!
			@pastOrder.completeWithinPastMonths?(1).should eql true
		end

		it "returns false for orders not within timeFrame" do
			@oldOrder.completeOrder!
			@oldOrder.completeWithinPastMonths?(3).should eql false
			@futureOrder.completeWithinPastMonths?(1).should eql false
		end



	end



	describe "#calculateCost" do

		it "calculates the cost for an order" do
			Order.changeSurcharge! 0
			@order.calculateCost.should eql 170
		end

		it "adds surcharge for order on weekend and doesn't on other order" do
			(@weekendOrder.calculateCost+@weekendOrder.orderSurcharge).should eql 175
			@order.calculateCost.should eql 170
		end
	end
	

	describe "#changeSurcharge!" do

		it "changes the global value of the surcharge to $5" do 
			Order.changeSurcharge! 5
			Order.surcharge.should eql 5
		end

	end

	describe "#changeQuantityOfItem!" do

		it "changes the quantity of the 1st item to 20" do
			@order.changeQuantityOfItem!(0,20)
			@order.itemsInOrder[0][1].should eql 20
		end

		it "does not change the quantity when given invalid location" do
			@order.changeQuantityOfItem!(4,20).should eql "InvalidLocation"
		end

		it "does not change the quantity when below minimum quantity" do
			@order.changeQuantityOfItem!(1,2).should eql "InvalidQuantity"
		end

	end

	describe "#validLocation?" do

		it "returns true if the location is valid for an order" do
			@order.validLocation?(1).should eql true
		end

		it "returns false for invalid locations for an order" do
			@order.validLocation?(-1).should eql false
			@order.validLocation?(2).should eql false
		end
	end

	describe "#to_s" do

		it "creates a nice string of the order" do
			Order.changeSurcharge! 0
			@order.calculateCost
			@order.to_s.should eql "Order Id: #{@order.id}\nCustomer Name: CustomerLastName\nCustomer Email: Customer@email.com\nCustomer Phone: customerPhoneNumber\nDelivery Address: deliveryAddress\nDelivery Date & Time: #{@order.deliveryDate.to_s}\nSpecial Instructions:\nspecialInstructions\nItems Ordered:\nBBQ Beef Brisket $10.00 x 15\nCoke $2.00 x 10\n\nSurcharge Included: $0.00\nTotal Cost: $170.00" 
		end
	end

	describe "#to_JSON" do

		it "creates a JSON version of the Object" do
			@orderWithId.calculateCost
			jsonObject={}
			jsonObject[:id]=12345
			jsonObject[:order_date]=@orderWithId.orderDate
			jsonObject[:deliveryDate]=Time.new(2016, 06, 07, 3,30)
			jsonObject[:amount]=@orderWithId.finalCost
			jsonObject[:surcharge]=@orderWithId.orderSurcharge
			jsonObject[:status]=@orderWithId.getJsonOrderStatus
			jsonObject[:ordered_by]=@orderWithId.customer.email
			jsonObject[:order_detail]=@orderWithId.getJsonOrderDetail
			@orderWithId.to_JSON.should eql jsonObject			
		end

	end

	describe "#getJsonOrderDetail" do

		it "gets the Order Detail in Json Format" do
			orderDetail=@order.getJsonOrderDetail
			jsonMenuItem1={}
			jsonMenuItem1[:id]=123
			jsonMenuItem1[:name]="BBQ Beef Brisket"
			jsonMenuItem1[:count]=15
			jsonMenuItem2={}
			jsonMenuItem2[:id]=124
			jsonMenuItem2[:name]="Coke"
			jsonMenuItem2[:count]=10
			jsonObject=[jsonMenuItem1,jsonMenuItem2]
			orderDetail.should eql jsonObject
		end
	end

	describe "#getJsonOrderStatus" do

		it "gets the correct oder status for an order" do
			@order.getJsonOrderStatus.should eql "open"
		end

		it "retusn status cancelled for cancelled order" do
			@tomorrowOrder.cancelOrder!
			@tomorrowOrder.getJsonOrderStatus.should eql "cancelled"
		end

		it "returns delivered status for orders compelted" do
			@todayOrder.order_status=2
			@todayOrder.getJsonOrderStatus.should eql "delivered"
		end

	end
	describe "#to_ShortJson" do

		it "gets a shorter version of the Json object" do
			@orderWithId.calculateCost
			jsonObject={}
			jsonObject[:id]=12345
			jsonObject[:order_date]=@orderWithId.orderDate
			jsonObject[:deliveryDate]=Time.new(2016, 06, 07, 3,30)
			jsonObject[:amount]=@orderWithId.finalCost
			jsonObject[:surcharge]=@orderWithId.orderSurcharge
			jsonObject[:status]=@orderWithId.getJsonOrderStatus
			@orderWithId.to_ShortJson.should eql jsonObject
		end 
	end

	describe "#itemsOrdered_to_s" do

		it "creates readable string version of item, price and quantity" do
			@order.itemsOrdered_to_s.should eql "\nBBQ Beef Brisket $10.00 x 15\nCoke $2.00 x 10"
		end
	end

	describe "#isMatch?" do
		it "customer should match the query " do
			@order.isMatch?("cust").should eql true
		end
	end

	describe "#surchargeDates" do

		it "returns the surcharge dates" do
			Order.removeAllSurchargeDates!
			Order.surchargeDates.should eql []
		end

	end


	describe "#addSurchargeDate!" do
		it "Adds a surcharge date to the array of surcharge Dates" do
			dateNow=Time.now
			Order.addSurchargeDate!(dateNow)
			Order.surchargeDates.include?(dateNow).should eql true
			Order.removeAllSurchargeDates!
		end
	end

	describe "#removeAllSurchargeDates!" do

		it "removes all surchargeDates" do
			dateNow=Time.now
			Order.addSurchargeDate!(dateNow)
			Order.surchargeDates.include?(dateNow).should eql true
			Order.removeAllSurchargeDates!
			Order.surchargeDates.should eql []
		end

	end

	describe "#removeSurchargeDate!" do

		it "Removes a surcharge date given the location" do
			Order.removeAllSurchargeDates!
			dateNow=Time.now
			Order.addSurchargeDate!(dateNow)
			Order.surchargeDates.include?(dateNow).should eql true
			Order.removeSurchargeDate!(0)
			Order.surchargeDates.include?(dateNow).should eql false
			Order.removeAllSurchargeDates!
		end

		it "does nothing if given invalid location" do
			dateNow=Time.now
			Order.addSurchargeDate!(dateNow)
			Order.surchargeDates.include?(dateNow).should eql true
			Order.removeSurchargeDate!(3)
			Order.surchargeDates.include?(dateNow).should eql true
		end

	end
end
