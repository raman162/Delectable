class Admin

	attr_accessor 


	def initialize 
	end

	def changeSurcharge!(newSurcharge)
		Order.changeSurcharge!(newSurcharge) if newSurcharge > 0
	end

	def addSurchargeDate!(newSurchargeDate)
		Order.addSurchargeDate!(newSurchargeDate)
	end

	def removeSurchargeDate!(location)
		Order.removeSurchargeDate!(location)
	end

	def removeAllSurchargeDates!
		Order.removeAllSurchargeDates!
	end

	def addItemToMenu!(menu, menuItem)
		menu.addItem!(menuItem)
	end

	def updateMenuItemPrice!(menu, id, price)
		if menu.doesMenuItemExist?(id)
			menu.menuItems[id].price_per_person=price
		end
	end

	def updateOrderToDelivered!(order)
		order.order_status=2
	end
end