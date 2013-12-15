# -*- encoding : utf-8 -*-

require 'RMagick'

class NoisyImage
	include Magick

	attr_reader :code, :code_image

	# Jiggle = 15
	# Wobble = 15

	# def initialize(len)
		# puts "!!!!! start @ #{Time.now.to_f}"
		# chars = ('a'..'z').to_a - ['a','e','i','o','u']
		# colors = ['green', 'red', 'yellow']

		# code_array = []

		# 1.upto(len) {code_array << chars[rand(chars.length)]}

		# granite = Magick::ImageList.new('xc:#EDF7E7')
		# canvas = Magick::ImageList.new
		# canvas.new_image(32*len, 50, Magick::TextureFill.new(granite))

		# puts "!!!!! check point 1 @ #{Time.now.to_f}"

		# text = Magick::Draw.new
		# text.font_family = 'times'
		# text.pointsize = 30
		# cur = 10

		# code_array.each {|c|
			# rand(10) > 5 ? rot = rand(Wobble): rot = -rand(Wobble)
			# rand(10) > 5 ? weight = NormalWeight : weight = BoldWeight

			# text.annotate(canvas,0,0,cur,rand(Jiggle),c) {
				# self.rotation = rot
				# self.font_weight = weight
				# self.fill = colors[rand(colors.length)]
			# }
			# cur += 30
		# }

		# puts "!!!!! check point 2 @ #{Time.now.to_f}"

		# img = canvas.cur_image
		# # puts img
		# img.add_noise(PoissonNoise)

		# puts "!!!!! end @ #{Time.now.to_f}"

		# @code = code_array.to_s

		# @code_image = canvas.to_blob {
			# self.format = "gif"
		# }
	# end


	def initialize(length = 4)
		_PLATFORM = RUBY_PLATFORM.scan(/^([A-Za-z0-9_]+)-([A-Za-z_]+)/)[0]
		_IS_X86_64 = false		# (_PLATFORM[0] == "x86_64")
		
		img_width = 96
		img_height = 32

		text_width = img_width / length

		font_size = 24
		rand_height = 5
		colors = ['#FF0000', '#3300CC', '#FF3300', '#b50000', '#373000', '#f000f0', '##336600']
		valid_bg_line_colors = ['#ABEFAB', '#FF99FF', '#CCCCFF', '#66FF66', '#CCFF33']
		valid_chars = ('a'..'z').to_a #- ['l','o'] + (2..9).to_a
		dist = (5..10).to_a
		rotation = (-10..10).to_a
		x_pos = _IS_X86_64 ? -24 : 0

		puts "!!!!! start @ #{Time.now.to_f}"

		chars = []
		length.times {|x| chars << valid_chars[rand(valid_chars.size)].to_s }

		bglinecolor = valid_bg_line_colors[rand(valid_bg_line_colors.size)]

		canvas = ImageList.new
		canvas.new_image(img_width, img_height, HatchFill.new('white', bglinecolor, dist[rand(dist.size - 1)]))

		text = Draw.new
		#使用字体文件和直接使用字体，或者不写font, font_family两个属性都是如图所示结果，linux下无字显示
		# text.font = "fonts/" + ['times.ttf', 'arial.ttf', 'verdana.ttf', 'artro.ttf'][rand(4)]
		# text.font_family = 'times'
		#text.font_family = ['times', 'sans', 'fixed', 'Verdana'].sort{rand}.pop
		text.font = "fonts/times.ttf"
		text.font_weight = BoldWeight
		# text.text(0, 0, ' ')

		puts "!!!!! check point 1 @ #{Time.now.to_f}"

		chars.each do |char|
			y_pos = _IS_X86_64 ? 0 : (font_size + rand(rand_height))
			text.annotate(canvas, 0, 0, x_pos, y_pos, char) {
				self.rotation = rotation[rand(rotation.size)]
				self.fill = colors[rand(colors.size)]
				self.pointsize = font_size - rand(font_size >> 2)
			}
			x_pos += (text_width - rand(text_width >> 2))
		end

		# puts "!!!!! check point 2 @ #{Time.now.to_f}"

		# text.draw(image)

		# puts "!!!!! check point 3 @ #{Time.now.to_f}"

		# canvas.cur_image.add_noise Magick::PoissonNoise

		puts "!!!!! end @ #{Time.now.to_f}"

		@code = chars.join('').to_s
		@code_image = canvas.to_blob{ self.format = "gif" }
	end



	# def initialize(length = 4)
		# font_size = 32
		# # top_margin = 32
		# rand_height = 8
		# rand_space = 5
		# colors = ['#FF0000', '#3300CC', '#FF3300', '#b50000', '#373000', '#f000f0', '##336600']

		# # valid_bg_line_colors = ['#ABEFAB', '#FF99FF', '#CCCCFF', '#66FF66', '#CCFF33']
		# valid_chars = ('a'..'z').to_a
		# x_pos = 10

		# puts "!!!!! start @ #{Time.now.to_f}"

		# chars = []
		# length.times {|x| chars << valid_chars[rand(valid_chars.size)].to_s }
		# # bglinecolor = valid_bg_line_colors[rand(valid_bg_line_colors.size)]

		# canvas = ImageList.new
		# canvas.new_image(
			# length * font_size + x_pos,
			# font_size << 1
			# # HatchFill.new('white', bglinecolor, rand(5)+5)
		# )

		# image = canvas.cur_image
		# draw = Draw.new
		# #使用字体文件和直接使用字体，或者不写font, font_family两个属性都是如图所示结果，linux下无字显示
		# # draw.font = "fonts/" + ['times.ttf', 'arial.ttf', 'verdana.ttf', 'artro.ttf'][rand(4)]
		# # draw.font_family = 'times'
		# #draw.font_family = ['times', 'sans', 'fixed', 'Verdana'].sort{rand}.pop
		# draw.font = "fonts/times.ttf"
		# draw.font_weight = BoldWeight
		# draw.pointsize = font_size
		# draw.stroke = colors[rand(colors.size)]

		# puts "!!!!! check point 1 @ #{Time.now.to_f}"

		# chars.each do |char|
			# draw.text(x_pos, font_size + rand(rand_height), char)
			# x_pos += font_size + rand(rand_space)
		# end

		# puts "!!!!! check point 2 @ #{Time.now.to_f}"
		# # puts image.to_blob{ self.format = "gif" }

		# draw.draw(image)

		# puts "!!!!! check point 3 @ #{Time.now.to_f}"

		# image = image.add_noise(Magick::PoissonNoise)
		# # puts image.to_blob{ self.format = "gif" }

		# puts "!!!!! end @ #{Time.now.to_f}"

		# @code = chars.to_s()
		# @code_image = image.to_blob{ self.format = "gif" }
	# end
end
