class MenuItem

	attr_accessor :food, :price_per_person, :min_number_of_persons, :id

	def initialize food, price_per_person, min_number_of_persons
		@id= (food.name+food.category.to_s).gsub(/\s+/,"_").downcase.to_sym
		@food = food
		@price_per_person = price_per_person
		@min_number_of_persons= min_number_of_persons
	end

	def calculate_total_cost_of_item
		cost=@price_per_person * @min_number_of_persons
		cost
	end


	def foodName
		@food.name
	end

	def to_s
		"Name: " + self.foodName + "\nPrice Per Person: $" + sprintf("%.2f", @price_per_person) +"\nOrder for Minimum Number of Persons: #{@min_number_of_persons}"
	end


	def ==(menuItem)
		if menuItem.is_a? MenuItem
			@id==menuItem.id && @price_per_person==menuItem.price_per_person && @min_number_of_persons == menuItem.min_number_of_persons
		else
			false
		end
	end

	alias eql? ==

end
