require 'spec_helper'

describe Menu do
	
	before :all do
		bbqBeefBrisket=Food.new "BBQ Beef Brisket", :beef
		coke=Food.new "Coke", :drink
		pepsi=Food.new "Pepsi", :drink
		bbqChicken=Food.new "BBQ Chicken", :chicken
		lemonChicken=Food.new "Lemon Chicken", :chicken
		salmon=Food.new "Smoked Salmon", :fish
		@menuItems=[
			(@menuItem1=MenuItem.new bbqBeefBrisket, 10, 10),
			(@menuItem2=MenuItem.new coke, 2, 6),
			(@menuItem3=MenuItem.new pepsi, 2, 6),
			(@menuItem4=MenuItem.new bbqChicken, 5, 10),
			(@menuItem5=MenuItem.new lemonChicken, 6, 10), 
			(@menuItem6=MenuItem.new salmon, 10, 10)]
		lasagna=Food.new "Lasagna", :pasta
		@menuItem7=MenuItem.new lasagna, 5, 10
		@copyMenu=Menu.new [
			(@menuItem1=MenuItem.new bbqBeefBrisket, 10, 10),
			(@menuItem2=MenuItem.new coke, 2, 6),
			(@menuItem3=MenuItem.new pepsi, 2, 6),
			(@menuItem4=MenuItem.new bbqChicken, 5, 10),
			(@menuItem5=MenuItem.new lemonChicken, 6, 10), 
			(@menuItem6=MenuItem.new salmon, 10, 10),
			@menuItem7]
	
	
	end

	describe "#new" do

		it "Returns a new Menu Object" do
			@menu=Menu.new @menuItems
			@menu.should be_an_instance_of Menu
		end

	end

	describe "#==" do
		it "Ensures that two objects are equal in terms ofvalues and not exact references" do
			@menu=Menu.new @menuItems
			@similarMenu=Menu.new @menuItems
			@menu.should eql @similarMenu
		end

	end


	describe "#addItem" do
		
		it "Adds an menu Item to the Menu" do
			@menu=Menu.new @menuItems
			@menu.addItem(@menuItem7)
			@menu.should eql @copyMenu
		end

	end

end