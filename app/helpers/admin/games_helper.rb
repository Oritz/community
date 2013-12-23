# -*- encoding : utf-8 -*-
# require 'RMagick'

module Admin::GamesHelper
  def audited?(game_id,ids)
    for id in ids
      if  id == game_id
        return false
      end
    end
  end

  def resize_image?(src_filename, dest_filename, max_x=nil, max_y=nil)
    begin
      return false if (max_x == nil && max_y == nil)

      src_img = Magick::Image.read(src_filename).first

      x = src_img.columns
      y = src_img.rows
      ratio = (1.0*x)/y

      if max_y
        new_y = max_y
        new_x = ratio * new_y
      else
        new_x = max_x
        new_y = max_x / ratio
      end

      if new_x > max_x
        new_x = max_x
        new_y = new_x / ratio
      end

      src_img.resize!(x, new_y)
      src_img.resize!(new_x, new_y)

      src_img.write(dest_filename){self.quality = 80}
      true
    rescue
      false
    end
  end
end
