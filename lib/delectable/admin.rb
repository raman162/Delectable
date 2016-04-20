class Admin

	attr_accessor :menu


	def initialize  menu
		@menu=menu
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


end