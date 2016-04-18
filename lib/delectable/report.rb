class Report

	attr_accessor :orders, :name, :startDate, :endDate, :id, :filteredOrders
	attr_reader :creationDate

	def initialize orders, name, startDate=false, endDate=false, id=false
		@orders=orders
		@name=name
		@startDate=startDate
		@endDate=endDate
		@creationDate=Time.now
		if id==false
			@id=self.object_id
		else
			@id=id
		end
	end
	def getFilteredOrders
		filteredOrders=[]
		@orders.each do |order|
			order.calculateCost
			filteredOrders << order if order.dueWithinTheRange?(@startDate,@endDate) && order.order_status != 0
		end
		filteredOrders
	end

	def changeStartDate!(newStartDate)
		@startDate=newStartDate
	end

	def changeEndDate!(newEndDate)
		@endDate=newEndDate 
	end

	def to_JSON
		jsonObject={:id => @id, :name => @name}
	end

	def == report
		if report.is_a? Report
			@name==report.name
		end
	end

	alias eql? ==

end

class OrderReport < Report
	
	def generateReport
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
		@endDate=@startDate+86399
		generateReport
	end

	def generateTomorrowOrderReport
		@startDate=Time.new(Time.now.year, Time.now.month, Time.now.day) + 86400
		@endDate=@startDate+86399
		generateReport
	end


end

class RevenueReport < Report

	
	def generateReport 
		jsonObject={}
		jsonObject[:name]=name
		filteredOrders=self.getFilteredOrders
		@startDate==false ? jsonObject[:start_date]="NA" : jsonObject[:start_date]=@startDate 
		@endDate==false ? jsonObject[:end_date]="NA" : jsonObject[:end_date]=@endDate 
		jsonObject[:orders_placed]=filteredOrders.length
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