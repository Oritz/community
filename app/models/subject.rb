require 'sonkwo/exp'

class Subject < ActiveRecord::Base
  attr_accessible :title, :content, :main_body

  acts_as_polymorphic class_name: 'Post', name: 'detail', association: 'post'
  #acts_as_post
  #acts_as_behavior_provider author_key: "posts.account_id",
  #  timestamp: "posts.created_at",
  #  status: "posts.status",
  #  joins: "INNER JOIN posts ON posts.id=subjects.id",
  #  find_options: {include: [post: [:creator]]}
  acts_as_api
  api_accessible :preview do |t|
    t.add :content
    t.add :title
    t.add :post_images
  end

  #exp_hookable account: "self.creator", setting_name: "exp_subject_value"

  # Callbacks
  before_save :add_subject_count
  before_save :add_exp

  # Validations
  validates :content, presence: true, length: { maximum: 140 }, if: Proc.new { |a| a.status != Post::STATUS_PENDING }
  validates :main_body, presence: true, if: Proc.new { |a| a.status != Post::STATUS_PENDING }
  validates :title, presence: true, length: { maximum: 64 }, if: Proc.new { |a| a.status != Post::STATUS_PENDING }

  # Associations
  #belongs_to :group

  # Scopes

  # Methods
  def post_pending
    if self.status == Post::STATUS_PENDING
      self.status = Post::STATUS_NORMAL
      @is_post_pending = true
      if self.save
        @is_post_pending = false
        true
      else
        @is_post_pending = false
        false
      end
    else
      false
    end
  end

  def display_content
    cooked_content = []
    cached_images = {}
    self.content.each_line do |line|
      cooked_line = CGI.escapeHTML(line)
      # find all images
      cooked_line.gsub!(/&lt;#{Settings.posts.image_tag}(\d+)&gt;/) do |post_image_str|
        if cached_images.has_key?($1)
          post_image = cached_images[$1]
        else
          post_image = PostImage.where(id: $1).first
          if post_image
            cached_images[$1] = post_image
          end
        end
        if post_image
          post_image_str = "<img src='#{post_image.cloud_storage.url}'>"
        else
          post_image_str = post_image_str
        end
      end
      # find all href
      cooked_line.gsub!(/&lt;a href=&quot;(.*?)&quot;&gt;(.*?)&lt;\/a&gt;/) do |linked_str|
          linked_str = "<a target='_blank' rel='nofollow' href='#{$1}' title='#{$1}'>#{$2}</a>"
      end
      cooked_content.append(cooked_line + '<br>')
    end
    cooked_content.reduce(:concat)
  end

  private
  def add_subject_count
    if @is_post_pending || (new_record? && self.status != Post::STATUS_PENDING)
      self.creator.subject_count += 1
      self.creator.save!
    end
  end

  def add_exp
    if @is_post_pending || (new_record? && self.status != Post::STATUS_PENDING)
      Sonkwo::Exp.increase("exp_post_subject", self.creator, self.created_at)
    end
  end
end
