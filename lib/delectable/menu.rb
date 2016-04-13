class Menu

	attr_accessor :menuItems

	def initialize(menuItems=[])
		@menuItems=Hash.new
		if menuItems
			menuItems.each do |menuItem|
				@menuItems[menuItem.id]=menuItem
			end
		end
	end


	def getMenuItem(id)
		if @menuItems.has_key?(id)
			@menuItems[id]
		else
			false
		end
	end


	def addItem!(menuItem)
		if @menuItems.length > 0
			@menuItems[menuItem.id]=menuItem unless @menuItems.has_key?(menuItem.id)
		else
			@menuItems[menuItem.id]=menuItem
		end

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

	def search(query)
		newMenu=Menu.new
		@menuItems.each do |id,menuItem|
			if menuItem.isMatch? query
				newMenu.menuItems[id]=menuItem
			end
		end
		newMenu
	end

	def doesMenuItemExist?(id)
		@menuItems.has_key?(id)
	end

	alias find search
	
	def to_s
		menuString=""
		@menuItems.each do |id,menuItem|
			menuString=menuString+"\n**********\n"+menuItem.to_s
		end
		menuString
	end

	def to_JSON
		menuItemJsonArray=[]
		@menuItems.each do |id, menuItem|
			menuItemHash=menuItem.to_JSON
			menuItemJsonArray<<(menuItemHash)
		end
		menuItemJsonArray
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

	def Menu.menuItemsEqual?(menu1Hash, menu2Hash)
		matchCount=0
		menu1Hash.each do |id, menuItem1|
			menu2Hash.each do |id, menuItem2|
				if menuItem1 == menuItem2 
					matchCount += 1  
				end
			end
		end
		if matchCount == menu1Hash.length
			return true
		else
			return false
		end
	end

	alias eql? ==
end
