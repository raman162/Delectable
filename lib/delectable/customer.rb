class Customer
	attr_accessor :lastName, :phoneNumber, :email, :id
	def initialize firstName, lastName, phoneNumber, email, id=0
		@firstName=firstName
		@lastName=lastName
		@phoneNumber=phoneNumber
		@email=email
		if id == 0
			@id=self.object_id
		else
			@id=id
		end
	end

	def isMatch?(query)
		@lastName.downcase.include?(query.downcase) || @phoneNumber.downcase.include?(query.downcase) || @email.downcase.include?(query.downcase)
	end

	def hasSameEmail?(newEmail)
		@email==newEmail
	end

	def to_JSON
		jsonObject={}
		jsonObject[:id]=@id
		jsonObject[:name]=@firstName +" " +@lastName
		jsonObject[:email]=@email 
		jsonObject[:phone]=@phoneNumber
		jsonObject
	end
end