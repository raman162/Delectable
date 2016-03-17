class MenuItem
	attr_accessor :food, :price_per_person, :min_number_of_persons, :id

	def initialize food, price_per_person, min_number_of_persons
		@id= (food.name+food.categories.to_s).gsub(/\s+/,"_").downcase.to_sym
		@food = food
		@price_per_person = price_per_person
		@min_number_of_persons= min_number_of_persons
	end

	def hashIdGenerator
		catString=""
		@food.categories.each do |category| 
			catString=catString+category.to_s
		end
		return (@food.name+catString).gsub(/\s+/,"_").downcase.to_sym
	end

	def calculate_total_cost_of_item
		cost=@price_per_person * @min_number_of_persons
		cost
	end

	def categories
		@food.categories
	end
	
	def foodName
		@food.name
	end

	def to_s
		"Name: " + self.foodName + "\nPrice Per Person: $" + sprintf("%.2f", @price_per_person) +"\nOrder for Minimum Number of Persons: #{@min_number_of_persons}"
	end


	def isMatch?(query) 
		@food.name.downcase.include? query.downcase
	end


	def ==(menuItem)
		if menuItem.is_a? MenuItem
			@food==menuItem.food && @price_per_person==menuItem.price_per_person && @min_number_of_persons == menuItem.min_number_of_persons
		end
	end

	alias eql? ==

end
