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
		@order=Order.new  "CustomerFirstName", "CustomerLastName", "Customer@email.com", "customerPhoneNumber", menuOrders, "deliveryAddress", deliveryDate, "specialInstructions"
		@copyOrder=Order.new  "CustomerFirstName", "CustomerLastName", "Customer@email.com", "customerPhoneNumber", menuOrders, "deliveryAddress", deliveryDate, "specialInstructions"
		@todayOrder=Order.new  "CustomerFirstName", "CustomerLastName", "Customer@email.com", "customerPhoneNumber", menuOrders, "deliveryAddress", todayDate, "specialInstructions"
		@orderWithId =Order.new  "CustomerFirstName", "CustomerLastName", "Customer@email.com", "customerPhoneNumber", menuOrders, "deliveryAddress", deliveryDate, "specialInstructions", 12345
		@pastOrder =Order.new  "CustomerFirstName", "CustomerLastName", "Customer@email.com", "customerPhoneNumber", menuOrders, "deliveryAddress", pastDate, "specialInstructions", 12345
		@weekendOrder = Order.new  "CustomerFirstName", "CustomerLastName", "Customer@email.com", "customerPhoneNumber", menuOrders, "deliveryAddress", weekendDate, "specialInstructions"
		@oldOrder=Order.new  "CustomerFirstName", "CustomerLastName", "Customer@email.com", "customerPhoneNumber", menuOrders, "deliveryAddress", oldDate, "specialInstructions"
		@futureOrder=Order.new  "CustomerFirstName", "CustomerLastName", "Customer@email.com", "customerPhoneNumber", menuOrders, "deliveryAddress", futureDate, "specialInstructions"
		orders=[@order, @todayOrder, @pastOrder, @oldOrder, @futureOrder]
		@admin=Admin.new orders, menu
	end



	describe "#new" do

		it "returns a new Admin object" do
			@admin.should be_an_instance_of Admin
		end
	end
end