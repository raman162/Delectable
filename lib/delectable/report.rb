class Report

	attr_accessor :orders, :name, :startDate, :endDate, :id, :filteredOrders

	def initialize orders, name, startDate=false, endDate=false, id=false
		@orders=orders
		@name=name
		@startDate=startDate
		@endDate=endDate
		if id==false
			@id=self.object_id
		else
			@id=id
		end
	end
	def getFilteredOrders
		filteredOrders=[]
		@orders.each do |order|
			filteredOrders << order if order.dueWithinTheRange?(@startDate,@endDate)
		end
		filteredOrders
	end

	def changeStartDate!(newStartDate)
		@startDate=newStartDate if newStartDate.class == Time
	end

	def changeEndDate!(newEndDate)
		@endDate=newEndDate if newEndDate.class == Time
	end

	def to_JSON
		jsonObject={:id => @id, :name => @name}
	end

end

class OrderReport < Report
	
	def generateOrderReport
		filteredOrders=self.getFilteredOrders
		report={}
		report[:id]=@id
		report[:name]=@name
		ordersJson=[]
		filteredOrders.each do |order|
			ordersJson << order.to_JSON
		end
		report[:orders]=ordersJson
		report
	end

	def generateTodayOrderReport
		@startDate=Time.new(Time.now.year, Time.now.month, Time.now.day)
		@endDate=@startDate+86400
		generateOrderReport
	end

	def generateTomorrowOrderReport
		@startDate=Time.new(Time.now.year, Time.now.month, Time.now.day) + 86400
		@endDate=@startDate+86400
		generateOrderReport
	end
end

class RevenueReport < Report

	
	def generateRevenueReport 
		jsonObject={}
		jsonObject[:name]=name
		@startDate==false ? jsonObject[:start_date]="NA" : jsonObject[:start_date]=@startDate 
		@endDate==false ? jsonObject[:end_date]="NA" : jsonObject[:end_date]=@endDate 
		jsonObject[:orders_placed]=@orders.length
		jsonObject[:orders_cancelled]=self.countOrdersCancelled
		jsonObject[:orders_open]=self.countOrdersOpen
		jsonObject[:food_revenue]=self.calculateFoodRevenue
		jsonObject[:surcharge_revenue]=self.calculateSurchargeRevenue
		jsonObject
	end


	def countOrdersCancelled 
		filteredOrders=self.getFilteredOrders
		cancelOrderCount=0
		filteredOrders.each do |order|
			cancelOrderCount+=1 if order.order_status == 0
		end
		cancelOrderCount
	end

	def countOrdersOpen
		filteredOrders=self.getFilteredOrders
		openOrderCount=0
		filteredOrders.each do |order|
			openOrderCount+=1 if order.order_status == 1
		end
		openOrderCount

	end



	def calculateFoodRevenue
		filteredOrders=self.getFilteredOrders
		foodRevenue=0
		filteredOrders.each do |order|
			orderCost=order.calculateCost
			foodRevenue+=orderCost
		end
		foodRevenue
	end

	def calculateSurchargeRevenue
		filteredOrders=self.getFilteredOrders
		surchargeRevenue=0
		filteredOrders.each do |order|
			surchargeRevenue+=order.orderSurcharge
		end
		surchargeRevenue
	end



end