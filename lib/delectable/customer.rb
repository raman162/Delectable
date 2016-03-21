class Customer
	attr_accessor :lastName, :phoneNumber, :email
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

end