class Menu

	attr_accessor :menuItems

	def initialize(menuItems)
		@menuItems=Hash.new
		menuItems.each do |menuItem|
			@menuItems[menuItem.id]=menuItem
		end
	end


	def addItem(menuItem)
		menuId=menuItem.id
		 @menuItems[menuId]=menuItem unless @menuItems.has_value?(foodName)
	end

	# def ==(menu)
	# 	if @menuItems.length == menu.menuItems.length
	# 		@menuItems.each

	# end

end
