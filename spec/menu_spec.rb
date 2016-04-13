require 'spec_helper'

describe Menu do
	
	before :each do
		bbqBeefBrisket=Food.new "BBQ Beef Brisket", [:beef,:meat]
		coke=Food.new "Coke", [:drink]
		pepsi=Food.new "Pepsi", [:drink]
		bbqChicken=Food.new "BBQ Chicken", [:chicken,:meat]
		lemonChicken=Food.new "Lemon Chicken", [:chicken,:meat]
		salmon=Food.new "Smoked Salmon", [:fish,:pescatarian]
		@menuItems=[
			(@menuItem1=MenuItem.new bbqBeefBrisket, 10, 10, 121),
			(@menuItem2=MenuItem.new coke, 2, 6, 122),
			(@menuItem3=MenuItem.new pepsi, 2, 6, 123),
			(@menuItem4=MenuItem.new bbqChicken, 5, 10, 124),
			(@menuItem5=MenuItem.new lemonChicken, 6, 10, 125), 
			(@menuItem6=MenuItem.new salmon, 10, 10, 126)]
		lasagna=Food.new "Lasagna", [:pasta]
		@menuItem7=MenuItem.new lasagna, 5, 10, 128
		@copyMenu=Menu.new [
			(@menuItem1=MenuItem.new bbqBeefBrisket, 10, 10, 121),
			(@menuItem2=MenuItem.new coke, 2, 6, 122),
			(@menuItem3=MenuItem.new pepsi, 2, 6, 123),
			(@menuItem4=MenuItem.new bbqChicken, 5, 10, 124),
			(@menuItem5=MenuItem.new lemonChicken, 6, 10, 125), 
			(@menuItem6=MenuItem.new salmon, 10, 10, 126),
			@menuItem7]
		@differentMenu=Menu.new [@menuItem1,@menuItem2, @menuItem3, @menuItem4, @menuItem5, @menuItem7]
		@drinkMenu=Menu.new [@menuItem2, @menuItem3]
		@chickenAndDrinkMenu=Menu.new [@menuItem2, @menuItem3, @menuItem4, @menuItem5]
		@meatAndChickenMenu=Menu.new [@menuItem1, @menuItem4, @menuItem5]
		@bbqMenu=Menu.new [@menuItem1, @menuItem4]
		@chickenMenu=Menu.new [@menuItem5, @menuItem4]
		@chickenAndPastaMenu=Menu.new [@menuItem4, @menuItem5, @menuItem7]

	end

	describe "#new" do

		it "Returns a new Menu Object" do
			@menu=Menu.new @menuItems
			@menu.should be_an_instance_of Menu
		end

		it "returns a new empty object when given no parameters" do
			@menu=Menu.new
			@menu.should be_an_instance_of Menu
			@menu.menuItems.length.should eql 0
		end

	end


	describe "#menuItemsEqual?" do

		it "checks to see if the hash is equal" do
			@menu=Menu.new @menuItems
			@similarMenu=Menu.new @menuItems
			(Menu.menuItemsEqual?(@menu.menuItems, @similarMenu.menuItems)).should eql true
			Menu.menuItemsEqual?(@menu.menuItems, @differentMenu.menuItems).should_not eql true
		end

	end

	describe "#to_s" do

		it "creates string version of menu" do
			@drinkMenu.to_s.should eql "\n**********\n" +"Name: Coke\nPrice Per Person: $2.00\nOrder for Minimum Number of Persons: 6"+"\n**********\nName: Pepsi\nPrice Per Person: $2.00\nOrder for Minimum Number of Persons: 6"
		end

	end


	describe "#to_JSON" do
		
		it "creates a Json version of the object" do
			@menu=Menu.new [@menuItem7]
			jsonObject={}
			jsonObject[:id] = 128
			jsonObject[:name] = "Lasagna"
			jsonObject[:price_per_person] = 5
			jsonObject[:minimum_order] = 10
			jsonObject[:categories] = [:pasta]
			@menu.to_JSON.should eql [jsonObject]
		end
	
	end

	describe "#==" do
		it "Ensures that two objects are equal in terms ofvalues and not exact references" do
			@menu=Menu.new @menuItems
			@similarMenu=Menu.new @menuItems
			@menu.should eql @similarMenu
			puts "Testing against the copy menu"
			@menu.should_not eql @copyMenu
		end

	end

	describe "#getMenuItem" do

		it "returns a menu Item when given good id" do
			@menu=Menu.new @menuItems
			@menu.getMenuItem(121).should eql @menuItem1
		end

		it "returns false when no menu Item exists" do
			@menu=Menu.new @menuItems
			@menu.getMenuItem(300).should eql false
		end
	end

	describe "#addItem!" do
		
		it "Adds an menu Item to the Menu" do
			@menu=Menu.new @menuItems
			@menu.addItem!(@menuItem7)
			@menu.should eql @copyMenu
		end

		it "Adds a menu Item to a new menu" do
			@emptyMenu=Menu.new
			@emptyMenu.addItem! (@menuItem7)
			@newMenu = Menu.new ([@menuItem7])
			@emptyMenu.should eql @newMenu
		end
	end

	describe "#removeItem!" do

		it "Removes an item form the menu" do
			@menu=Menu.new @menuItems
			expect(@copyMenu).not_to eq @menu
			@copyMenu.removeItem!(@menuItem7)
			expect(@copyMenu).to eq @menu
		end

	end

	describe "#showCategories" do

		it "returns a menu with the items with specefic categories" do
			drinkCategoryMenu=@copyMenu.showCategories([:drink])
			expect(drinkCategoryMenu).to eq @drinkMenu
			catMenu=@copyMenu.showCategories([:chicken, :drink])
			expect(catMenu).to eq @chickenAndDrinkMenu
			catMenu=@copyMenu.showCategories([:chicken, :meat])
			expect(catMenu).to eq @meatAndChickenMenu
			catMenu=@copyMenu.showCategories([:chicken, :pasta])
			expect(catMenu).to eq @chickenAndPastaMenu

		end

	end


	describe "#search" do

		it "returns a menu matching the searched query" do
			expect(@copyMenu.search("bbq")).to eq @bbqMenu
			expect(@copyMenu.search("chick")).to eq @chickenMenu
		end
			
		it "returns an empty menu when no menu items match the query" do
			expect(@copyMenu.find("drink")).to eq Menu.new

		end

	end

	describe "#doesMenuItemExist?" do

		it "returns true for a menu Item with the matching Id" do
			@menu=Menu.new @menuItems
			@menu.doesMenuItemExist?(121).should eql true
		end

		it "returns false for a menu Item without a matchind Id" do
			@menu=Menu.new @menuItems
			@menu.doesMenuItemExist?(300).should eql false
		end
	end

end