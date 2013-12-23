# -*- encoding : utf-8 -*-
class Recommendation < ActiveRecord::Base
  attr_accessible :title, :body, :recommend_type, :link, :weight, :comment
  RECOMMEND_TYPE_TOP 			= 0
  RECOMMEND_TYPE_NORMAL 	= 1
  RECOMMEND_TYPE_FOCUS 		= 2
  belongs_to :game, foreign_key: 'link'

  scope :in_type, ->(type){where('recommend_type=?', type)}
  def picture
    Picture.new(self)
  end

end
