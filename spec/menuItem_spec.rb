require 'spec_helper'

describe MenuItem do

	# before :all do

	# end

	before :each do
		@food=Food.new "FoodName", [:foodCategory]
		@coke=Food.new "Coke", [:drink]
		@pepsi=Food.new "Pepsi", [:drink]
		@bbqChicken=Food.new "BBQ Chicken", [:chicken]
		@lemonChicken=Food.new "Lemon Chicken", [:chicken, :meat]
		@menuItem1=MenuItem.new @food, 10, 5
		@menuItem2=MenuItem.new @coke, 2, 6
		@menuItem3=MenuItem.new @pepsi, 2, 6
		@menuItem4=MenuItem.new @bbqChicken, 5, 10
		@menuItem5=MenuItem.new @lemonChicken, 6, 10
		@menuItemWithId=MenuItem.new @coke, 3, 6, 24 
		lasagna=Food.new "Lasagna", [:pasta]
		@menuItem7=MenuItem.new lasagna, 5, 10, 128
	end

	describe "#new" do
		
		it "returns a new MenuItem Object" do
			@menuItem1.should be_an_instance_of MenuItem
		end

		it "returns a new MenuItem Object when passed an ID" do
			@menuItemWithId.should be_an_instance_of MenuItem
		end
	end

	describe "#calculate_total_cost_of_item" do

		it "returns the total cost of the menu Item" do
			expect(@menuItem1.calculate_total_cost_of_item).to eq 50
		end
	end

	describe "#foodName" do

		it "returns the name of the food for the item" do
			@menuItem1.foodName.should eql "FoodName"
		end

	end

	

	describe "#categories" do

		it "returns the name of the category the food item is in" do
			expect(@menuItem1.categories).to eq [:foodCategory]
		end

	end



	describe "#to_s" do

		it "returns a string of the object" do
			@menuItem1.to_s.should eql "Name: FoodName\nPrice Per Person: $10.00\nOrder for Minimum Number of Persons: 5"
		end
	end


	describe "to_JSON" do

		it "returns a new MenuItem in the JSON Object format" do
			jsonObject={}
			jsonObject[:id] = 128
			jsonObject[:name] = "Lasagna"
			jsonObject[:price_per_person] = 5
			jsonObject[:minimum_order] = 10
			jsonObject[:categories] = [:pasta]
			@menuItem7.to_JSON.should eql jsonObject
		end

	end


	describe "#==" do
		it "checks to see if two menu items are the same" do
			@menuItem1.should eql MenuItem.new @food, 10, 5

		end
	end

	describe "#hashIdGenerator" do
		it "creates a hashId for the menu" do
			@menuItem1.hashIdGenerator.should eql :foodnamefoodcategory
			@menuItem5.hashIdGenerator.should eql :lemon_chickenchickenmeat
			puts @menuItem5.hashIdGenerator
		end
	end

	describe "#isMatch?" do

		it "returns true if string matches part of the name for the menuItem" do
			@menuItem4.isMatch?("bbq").should eql true
			@menuItem2.isMatch?("bbq").should_not eql true
		end			

	end





end
