# -*- encoding : utf-8 -*-
class GenerateMailValidationToken < Struct.new(:email)
	def create_email_token
		
		sceret_key = "54a73dfc18fbf824f5760998614da2e7"
		
		string_to_hash = sceret_key + email
		
		token = Digest::SHA1.hexdigest(string_to_hash)
		return token
	end
end
