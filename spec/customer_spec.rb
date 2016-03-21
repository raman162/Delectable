require 'spec_helper'

describe Customer do 

	before :each do
		@customer1=Customer.new "John", "Doe", "3124598501", "john@hawk.com" 
		@customer2=Customer.new "Joan", "Carey", "3123141242", "joan@hawk.com", 12345
	end

	describe "#new" do

		it "returns a new customer object" do
			@customer1.should be_an_instance_of Customer
		end

		it "returns a new customer object when given an id" do
			@customer2.should be_an_instance_of Customer
		end

	end


	describe "#isMatch?" do

		it "returns true if the customer matches the search" do
			@customer1.isMatch?("jo").should eql true
		end
	end

	describe "#hasSameEmail?" do

		it "returns true for matching emails" do
			@customer1.hasSameEmail?("john@hawk.com").should eql true
		end

		it "reuturns false for emails that don't match" do
			@customer1.hasSameEmail?("john1@hawk.com").should eql false
		end
	end
	
	
end