class Food

	attr_accessor :name, :categories
	def initialize name, categories
		@name=name
		@categories=categories
	end

	def addToCategories!(category)
		unless hasCategory?(category) 
			@categories<<category
		end
	end

	def hasCategory?(category)
		@categories.include? category
	end

	def == food
		if food.is_a? Food
			@name == food.name && @categories == food.categories
		end
	end

	alias eql? ==

end
