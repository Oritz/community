# -*- encoding : utf-8 -*-

class ClientFile

	DIRECTORY = "#{Rails.root}/public/sonkwo_client"
	STUB = "/sonkwo_client"
	def initialize(ver,type,client = nil)
		@ver = ver
		@type = type
		@client = client


		FileUtils.mkdir_p("#{DIRECTORY}/#{type}") unless File.directory?("#{DIRECTORY}/#{type}")
		
		if type == "patch_file"
			suffix = "msp"
		elsif type == "full_pkg_file"
			suffix = "msi"
		end
		
		@filename = "#{ver}.#{suffix}"

		@client_file = File.join("#{DIRECTORY}/#{@type}",@filename)
		
	end	

	def exists?

		File.exists?(@client_file)
	end
	
	alias exist? exists? #
	
	def client_path
		"#{DIRECTORY}/#{@type}/#{@filename}"
	end

	def client_digest
			 digest = Digest::SHA1.hexdigest(@client.read)
	end
	
	def save
		
		File.open(@client_file,"wb")do |f|
			f.write(@client.read)
			@client.rewind  #Positions ios to the beginning of input, resetting lineno to zero.
		end
	end
	
	def delete
		File.delete(@client_file) if File.exists?(@client_file)
	end
	
end
