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
		tomorrowDate=Time.now + 86400
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
		@admin=Admin.new
	end



	describe "#new" do

		it "returns a new Admin object" do
			@admin.should be_an_instance_of Admin
		end
	end

	describe "#addItemToMenu!" do

		it "adds a new menu Item to the menu" do
			mashPotato=Food.new("Mash Potato", [:vegiterian])
			menuItem8=MenuItem.new(mashPotato, 10, 10, 500)
			@admin.addItemToMenu!(@menu, menuItem8)
			@menu.doesMenuItemExist?(500).should eql true
		end

	end

	describe "updateMenuItemPrice!" do

		it "updates the price of a menu item" do
			@admin.updateMenuItemPrice!(@menu,123,15)
			@menu.getMenuItem(123).price_per_person.should eql 15
		end

		it "does not add a new menu item when given an invalid id" do
			@admin.updateMenuItemPrice!(@menu, 299, 15)
			@menu.doesMenuItemExist?(299).should eql false
		end
	end


	describe "updateOrderToDelivered!"  do
		
		it "updated an order status to delivered" do
			@admin.updateOrderToDelivered!(@todayOrder)
			@todayOrder.order_status.should eql 2
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