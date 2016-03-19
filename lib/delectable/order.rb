class Order
	@@surcharge=0
	@@weekendSurcharge=5
	@@id_setter=0
	ORDER_CANCELLED = 0
	ORDER_PENDING = 1
	ORDER_COMPLETE = 2
	attr_accessor :itemsInOrder, :order_status, :deliveryDate, :surcharge, :id
	attr_reader :id, :finalCost

	def initialize(customerFirstName, customerLastName, customerEmail, customerNumber, itemsInOrder, deliveryAddress, deliveryDate, specialInstructions, id=0)
		@customerFirstName = customerFirstName
		@customerLastName = customerLastName
		@customerEmail=customerEmail
		@customerNumber=customerNumber
		@itemsInOrder = itemsInOrder
		@deliveryAddress = deliveryAddress
		@deliveryDate = deliveryDate
		@specialInstructions = specialInstructions
		@order_status = ORDER_PENDING
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
		@deliveryDate.day == Time.now.day && @deliveryDate.month == Time.now.month && @deliveryDate.year==Time.now.year
	end

	def dueInThePast?
		@deliveryDate<Time.now
	end

	def dueInTheFuture?
		@deliveryDate>Time.now
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
		if @deliveryDate.saturday? || @deliveryDate.sunday?
			cost+=@@weekendSurcharge
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


	def to_s
		order_id="Order Id: #{@id}"
		customer_info="\nCustomer Last Name: #{@customerLastName}\nCustomer Email: #{@customerEmail}\nCustomer Phone: #{@customerNumber}"
		delivery_info="\nDelivery Address: #{@deliveryAddress}\nDelivery Date & Time: #{@deliveryDate.to_s}"
		special_instructions="\nSpecial Instructions:\n#{@specialInstructions}"	
		items_info="\nItems Ordered:"+self.itemsOrdered_to_s
		charge_info="\n\nSurcharge Included: $"+sprintf("%.2f",@@surcharge) + "\nTotal Cost: $"+sprintf("%.2f", self.calculateCost)
		order_id+customer_info+delivery_info+special_instructions+items_info+charge_info	
	end

	def itemsOrdered_to_s
		itemString=""
		@itemsInOrder.each {|orderItem| itemString+= "\n"+orderItem[0].foodName+" $"+sprintf("%.2f",orderItem[0].price_per_person)+" x "+orderItem[1].to_s}
		itemString
	end


	def isMatch?(query)
		@customerLastName.include?(query) || @customerNumber.include?(query) || @customerEmail.include?(query)
	end
end