class Admin

	attr_accessor :customers, :orders, :menu


	def initialize orders, menu,  customers
		@orders=orders
		@menu=menu
		@customers=customers
	end

	def searchCustomers(query)
		matchingCustomers=[]
		@customers.each do |thisCustomer|
			matchingCustomers << thisCustomer if thisCustomer.isMatch?(query)
		end
		matchingCustomers
	end

	def findCustomerOrders(customer)
		customerOrders=[]
		customerEmail=customer.email
		@orders.each do |order|
			customerOrders << order if order.isMatch?(customerEmail)
		end
		customerOrders
	end

	def getOrdersDueToday
		ordersDueToday=[]
		@orders.each do |order|
			ordersDueToday << order if order.dueToday?
		end
		ordersDueToday
	end

	def getOrdersDueTomorrow
		ordersDueTomorrow=[] 
		@orders.each do |order|
			ordersDueTomorrow << order if order.dueTomorrow?
		end
		ordersDueTomorrow
	end

	def getOrdersDueThisDate(date)
		ordersDue=[]
		@orders.each do |order|
			ordersDue << order.to_JSON if order.dueThisDate?(date)
		end
		ordersDue
	end

	def numberOfOrdersCopmleteWithinPastMonths(months)
		monthCount=0
		@orders.each do |order|
			monthCount += 1 if order.completeWithinPastMonths?(months)
		end
		monthCount
	end

	def earningsWithinPastMonths(months) 
		earningsCount=0
		@orders.each do |order|
			earningsCount += order.finalCost if order.completeWithinPastMonths?(months)
		end
		earningsCount
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

	def ordersToJSON
		orderArray=[]
		@orders.each do |order|
			orderArray << order.to_JSON
		end
		orderArray
	end
end