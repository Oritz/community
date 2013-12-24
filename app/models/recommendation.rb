# -*- encoding : utf-8 -*-
class Recommendation < ActiveRecord::Base
  attr_accessible :title, :body, :recommend_type, :link, :weight, :comment, :picture
  RECOMMEND_TYPE_TOP 			= 0
  RECOMMEND_TYPE_NORMAL 	= 1
  RECOMMEND_TYPE_FOCUS 		= 2
  belongs_to :game, foreign_key: 'link'
  validates :recommend_type, :weight, :full_pic, presence: true
  scope :in_type, ->(type){where('recommend_type=?', type)}
  def picture
    Picture.new(self)
  end

  def picture=(pic)
    if pic
      file_type = pic.content_type.chomp
      if (file_type !~ /^image\/.*?jpeg|jpg|png|bmp|gif$/i)   # File type should be IMAGE
        self.errors[:base] << I18n.t('admin.errors.image_type_invalid')
      else
        @picture = pic
      end
    else
      self.errors[:base] << I18n.t('admin.errors.recommend_pic_is_null')
    end
  end

  def destroy
    super
    self.picture.delete
  end

  after_save :do_with_picture

  private
  def do_with_picture
    if have_picture?
      pic = Picture.new(self, @picture)
      pic.save
      self.full_pic = pic.url
      @picture = nil
      self.save
    end
  end

  def have_picture?
    @picture
  end
end
