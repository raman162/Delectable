require 'spec_helper'

describe Food do

	before :each do
		@food = Food.new "FoodName", :category
	end

	describe "#new" do
		
		it "returns a new Food Object" do
			@food.should be_an_instance_of Food
		end

		it "takes two paramaters and returns a food object" do
			lambda {Food.new "FoodName"}.should raise_exception ArgumentError
		end

	end


	describe "#name" do

		it "returns the Food's name" do
			@food.name.should eql "FoodName"
		end
	end

	describe "#category" do
		it "returns the Food's category" do
			@food.category.should eql :category
		end
	end

	describe "#to_s" do
		
		it "returns a string of the Food's name" do
			@food.to_s.should eql "FoodName"
		end
	end

	describe "#==" do

		it "checks to see if two food objects are equal" do
			@food.should eql (Food.new "FoodName", :category)
		end
	end

end