class Customer
	attr_accessor :name, :phoneNumber, :email, :id
	def initialize name, phoneNumber, email, id=0
		@name=name
		@phoneNumber=phoneNumber
		@email=email
		if id == 0
			@id=self.object_id
		else
			@id=id
		end
	end

	def isMatch?(query)
		@name.downcase.include?(query.downcase) || @phoneNumber.downcase.include?(query.downcase) || @email.downcase.include?(query.downcase)
	end

	def hasSameEmail?(newEmail)
		@email==newEmail
	end

	def to_JSON
		jsonObject={}
		jsonObject[:id]=@id
		jsonObject[:name]=@name
		jsonObject[:email]=@email 
		jsonObject[:phone]=@phoneNumber
		jsonObject
	end
end