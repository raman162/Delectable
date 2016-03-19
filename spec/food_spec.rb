require 'spec_helper'

describe Food do

	before :each do
		@food = Food.new "FoodName", [:category]
		@food2= Food.new "FoodName2", [:category1, :category2]
	end

	describe "#new" do
		
		it "returns a new Food Object" do
			@food.should be_an_instance_of Food
			@food2.should be_an_instance_of Food
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

	describe "#categories" do
		it "returns the Food's categories" do
			@food.categories.should eql [:category]
			@food2.categories.should eql [:category1, :category2]

		end
	end

	# describe "#to_s" do
		
	# 	it "returns a string of the Food's name" do
	# 		@food.to_s.should eql "FoodName"
	# 	end
	# end

	describe "#addToCategories!" do
		it "adds a category to the food's categories" do
			@food.addToCategories!(:category3)
			@food.categories[1].should eql :category3
		end
	end

	describe "hasCategory?" do
		it "returns true if category exists" do
			@food.hasCategory?(:category).should eql true
		end

		it "returns false if category does note exist" do
			@food.hasCategory?(:category3).should eql false
		end
	end

	describe "#==" do

		it "checks to see if two food objects are equal" do
			@food.should eql (Food.new "FoodName", [:category])
			@food.should == (Food.new "FoodName", [:category])
			@food2.should eql (Food.new "FoodName2", [:category1, :category2])
			expect(@food).not_to eq (Food.new "DiffFood", :diffcategory)
			expect(@food==(Food.new "DiffFood", :diffcategory)).to eq false
		end
	end

end