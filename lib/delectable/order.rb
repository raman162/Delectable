class Order
	@@surcharge=0
	@@weekendSurcharge=5
	@@id_setter=0
	@@surchargeDates=[]
	ORDER_CANCELLED = 0
	ORDER_PENDING = 1
	ORDER_COMPLETE = 2
	attr_accessor :itemsInOrder, :order_status, :deliveryDate, :orderSurcharge, :id
	attr_reader :id, :finalCost, :orderDate, :customer

	def initialize(customer, itemsInOrder, deliveryAddress, deliveryDate, specialInstructions, id=0)
		@customer=customer
		@itemsInOrder = itemsInOrder
		@deliveryAddress = deliveryAddress
		@deliveryDate = deliveryDate
		@specialInstructions = specialInstructions
		@order_status = ORDER_PENDING
		@orderSurcharge=0
		@orderDate=Time.now
		if id==0
			@id = self.object_id
		else
			@id=id
		end
	end


	def addItem!(menuItem, quantity)
		if quantity >= menuItem.min_number_of_persons && !@itemsInOrder.include?([menuItem, quantity])
			@itemsInOrder << [menuItem, quantity]
		end
	end

	def removeItem!(location)
		if validLocation?(location)
			@itemsInOrder.delete_at(location)
		end
	end

	def changeQuantityOfItem!(location, newQuantity)
		if validLocation?(location)
			if newQuantity >= @itemsInOrder[location][0].min_number_of_persons
				@itemsInOrder[location][1]=newQuantity
			else "InvalidQuantity"
			end
		else "InvalidLocation"
		end

	end

	def cancelOrder!
		unless self.dueToday?
			@order_status=ORDER_CANCELLED
		end
	end

	def validLocation?(location)
		location < @itemsInOrder.length && location > -1
	end

	def completeOrder!
		if self.dueToday? || self.dueInThePast?
			@order_status=ORDER_COMPLETE
		end
	end

	def dueToday?
		@deliveryDate.day == Time.now.day && @deliveryDate.month == Time.now.month && @deliveryDate.year==Time.now.year && order_status==ORDER_PENDING
	end

	def dueInThePast?
		@deliveryDate<Time.now && order_status==ORDER_PENDING
	end

	def dueInTheFuture?
		@deliveryDate>Time.now && order_status==ORDER_PENDING
	end

	def dueWithinDays?(days)
		dueDate=Time.now+days*86400
		order_status == ORDER_PENDING && dueDate >= @deliveryDate && @deliveryDate >= Time.now
	end

	def dueWithinTheRange?(startDate, endDate)
		match=nil
		if startDate == false && endDate == false
			match=true
		else
			match=@deliveryDate.between?(startDate,endDate)
		end
		if startDate==false && endDate!=false
			match=@deliveryDate < endDate
		end
		if endDate==false && startDate!=false
			match=@deliveryDate > startDate
		end
		match
	end

	def dueTomorrow?
		dueWithinDays?(1)
	end

	def dueThisDate?(date)
		@deliveryDate.day == date.day && @deliveryDate.month == date.month && deliveryDate.year == date.year && order_status != ORDER_CANCELLED
	end

	def completeWithinPastDays?(days)
		pastDate=Time.now-days*86400 	#86,400 seconds are within a day
		order_status==ORDER_COMPLETE && pastDate<=@deliveryDate
	end

	def completeWithinPastMonths?(months)
		completeWithinPastDays?(30*months)
	end


	def calculateCost
		cost=0
		if (@deliveryDate.saturday? || @deliveryDate.sunday?) 
			@orderSurcharge+=@@weekendSurcharge
		end

		@itemsInOrder.each {|orderItem| cost+=orderItem[0].price_per_person*orderItem[1]}
		@finalCost=cost+@@surcharge
		@finalCost
	end

	def Order.changeSurcharge! newSurcharge
		@@surcharge = newSurcharge
	end

	def Order.surcharge 
		@@surcharge
	end

	def Order.addSurchargeDate!(surchargeDate)
		@@surchargeDates << surchargeDate unless @@surchargeDates.include? surchargeDate
	end

	def Order.surchargeDates
		@@surchargeDates
	end

	def Order.removeAllSurchargeDates!
		@@surchargeDates=[]
	end

	def Order.removeSurchargeDate!(location)
		@@surchargeDates.delete_at(location) if (location > -1) && (location < @@surchargeDates.length)
	end



	def to_s
		order_id="Order Id: #{@id}"
		customer_info="\nCustomer Name: #{@customer.name}\nCustomer Email: #{@customer.email}\nCustomer Phone: #{@customer.phoneNumber}"
		delivery_info="\nDelivery Address: #{@deliveryAddress}\nDelivery Date & Time: #{@deliveryDate.to_s}"
		special_instructions="\nSpecial Instructions:\n#{@specialInstructions}"	
		items_info="\nItems Ordered:"+self.itemsOrdered_to_s
		charge_info="\n\nSurcharge Included: $"+sprintf("%.2f",@@surcharge) + "\nTotal Cost: $"+sprintf("%.2f", finalCost)
		order_id+customer_info+delivery_info+special_instructions+items_info+charge_info	
	end


	def itemsOrdered_to_s
		itemString=""
		@itemsInOrder.each {|orderItem| itemString+= "\n"+orderItem[0].foodName+" $"+sprintf("%.2f",orderItem[0].price_per_person)+" x "+orderItem[1].to_s}
		itemString
	end

	def to_JSON
		jsonObject={}
		jsonObject[:id]=@id
		jsonObject[:order_date]=@orderDate
		jsonObject[:deliveryDate]=@deliveryDate
		jsonObject[:amount]=@finalCost
		jsonObject[:surcharge]=@orderSurcharge
		jsonObject[:status]=@order_status
		jsonObject[:ordered_by]=@customer.email
		jsonObject
	end

	def isMatch?(query)
		@customer.isMatch?(query)
	end
end