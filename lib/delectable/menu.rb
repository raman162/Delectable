class Menu

	attr_accessor :menuItems

	def initialize(menuItems=[])
		@menuItems=Hash.new
		if menuItems
			menuItems.each do |menuItem|
				@menuItems[menuItem.hashIdGenerator]=menuItem
			end
		end
	end


	def addItem!(menuItem)
		menuId=menuItem.hashIdGenerator
		@menuItems[menuId]=menuItem unless @menuItems.has_key?(menuId)

	end

	def removeItem!(menuItem)
		if @menuItems.has_value?(menuItem) 
			@menuItems.delete(@menuItems.key(menuItem))
		end
	end

	def showCategories(categories)
		newMenu=Menu.new
		puts newMenu
		categories.each do |category|
			getCategoryMenuItems(category,newMenu)
		end
		newMenu
	end

	def getCategoryMenuItems(category, newMenu)
		@menuItems.each do |id, menuItem|
			if menuItem.categories.include? category
				newMenu.menuItems[id]=menuItem
			end
		end
	end


	def to_s
		menuString=""
		@menuItems.each do |id,menuItem|
			menuString=menuString+"\n**********\n"+menuItem.to_s
		end
		menuString
	end

	def ==(menu)
		match=true
		if @menuItems.length == menu.menuItems.length
			match=Menu.menuItemsEqual?(@menuItems, menu.menuItems)
		else
			return false
		end
		match
	end

	def search(query)
		newMenu=Menu.new
		@menuItems.each do |id,menuItem|
			if menuItem.isMatch? query
				newMenu.menuItems[id]=menuItem
			end
		end
		newMenu
	end

	def Menu.menuItemsEqual?(menu1Hash, menu2Hash)
		menu1Hash.each do |id, menuItem|
			other_menu_item=menu2Hash[id]
			if other_menu_item != menuItem
				return false
			end
		end
		return true
	end

	alias eql? ==
end
