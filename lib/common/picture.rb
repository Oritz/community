# -*- encoding : utf-8 -*-
class Picture
	#图像目录
	URL_STUB = "/images/recommendation"
	DIRECTORY = File.join("public","images","recommendation")
	#图像大小
	IMG_SIZE = '"1920x1200>"'
	THUMB_SIZE ='"100x100>"'
	
	def initialize(recommendation,image = nil)
		@recommendation = recommendation
		@image = image
		FileUtils.mkdir_p(DIRECTORY) unless File.directory?(DIRECTORY)
	end

	def url 
		"#{URL_STUB}/#{filename}"
	end

	def thumbnail_url
		"#{URL_STUB}/#{thumbnail_name}"
	end

	def save
		source = File.join("tmp","#{@recommendation.id}_full_size")
		full_size = File.join(DIRECTORY,filename)
		thumbnail = File.join(DIRECTORY,thumbnail_name)

		File.open(source,"wb"){ |f| f.write(@image.read)}

    #convert to thumbnail size and full size
		system("convert #{source} -resize #{IMG_SIZE} #{full_size}")
		system("convert #{source} -resize #{THUMB_SIZE} #{thumbnail}")
		File.delete(source) if exists?(source)
		return true
	end
	
	def delete
		[filename,thumbnail_name].each do |name|
			f = exists?(name)
			File.delete(f) if f
		end
  end

  def exists?(file_name=filename)
    file = File.join(DIRECTORY,file_name)
    if File.exists?(file)
      return file
    end
    return nil
  end

	private
	def filename
		"#{@recommendation.id}_#{@recommendation.recommend_type}.jpg"
	end

	def thumbnail_name
		"#{@recommendation.id}_#{@recommendation.recommend_type}_thumbnail.jpg"
	end
end
