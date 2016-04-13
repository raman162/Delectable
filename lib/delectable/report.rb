class Report

	attr_accessor :orders, :startDate, :endDate, :id

	def initialize orders, startDate=false, endDate=false, id=false
		@orders=orders
		@startDate=startDate
		@endDate=endDate
		if id==false
			@id=self.object_id
		else
			@id=id
		end
	end

end

class RevenueReport < Report

	
	def generateRevenueReport 
		jsonObject={}
		jsonObject[:name]="Revenue Report"
		@startDate==false ? jsonObject[:start_date]="NA" : jsonObject[:start_date]=@startDate 
		@endDate==false ? jsonObject[:end_date]="NA" : jsonObject[:end_date]=@endDate 
		jsonObject[:orders_placed]=@orders.length
	end


	def countOrdersCancelled 

	end

	def getFilteredOrders
		filteredOrders=[]
		@orders.each do |order|
			filteredOrders << order if order.dueWithinTheRange?(@startDate,@endDate)
		end
		filteredOrders
	end
end