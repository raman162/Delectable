require 'spec_helper'

describe MenuItem do

	# before :all do

	# end

	before :each do
		@food=Food.new "FoodName", :foodCategory
		@coke=Food.new "Coke", :drink
		@pepsi=Food.new "Pepsi", :drink
		@bbqChicken=Food.new "BBQ Chicken", :chicken
		@lemonChicken=Food.new "Lemon Chicken", :chicken
		@menuItem1=MenuItem.new @food, 10, 5
		@menuItem2=MenuItem.new @coke, 2, 6
		@menuItem3=MenuItem.new @pepsi, 2, 6
		@menuItem4=MenuItem.new @bbqChicken, 5, 10
		@menuItem5=MenuItem.new @lemonChicken, 6, 10 
	end

	describe "#new" do
		
		it "returns a new MenuItem Object" do
			@menuItem1.should be_an_instance_of MenuItem
		end

		it "checks to see if the id is correct" do
			@menuItem1.id.should eql :foodnamefoodcategory
			@menuItem4.id.should eql :bbq_chickenchicken
		end


		
	end

	describe "#calculate_total_cost_of_item" do

		it "returns the total cost of the menu Item" do
			@menuItem1.calculate_total_cost_of_item.should eql 50
		end
	end

	describe "#foodName" do

		it "returns the name of the food for the item" do
			@menuItem1.foodName.should eql "FoodName"
		end

	end

	describe "#to_s" do

		it "returns a string of the object" do
			@menuItem1.to_s.should eql "Name: FoodName\nPrice Per Person: $10.00\nOrder for Minimum Number of Persons: 5"
		end
	end


	describe "#==" do
		it "checks to see if two menu items are the same" do
			@menuItem1.should eql MenuItem.new @food, 10, 5
			
		end
	end




end
