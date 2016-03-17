class Food

	attr_accessor :name, :category
	def initialize name, category
		@name=name
		@category=category
	end

	def to_s
		@name
	end

	def == food
		if food.is_a? Food
			@name == food.name && @category == food.category
		else
			false
		end
	end

	alias eql? ==

end