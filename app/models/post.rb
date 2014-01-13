class Post < ActiveRecord::Base
  # Plugins
  #acts_as_behavior_provider author_key: "account_id",
  #  timestamp: "created_at",
  #  status: "status",
  #  find_options: {include: [:detail, :creator]}

  acts_as_tipoffable target: "creator"

  attr_accessor :cloud_storage_id # Just used in talks
  attr_accessible :content, :cloud_storage_id, :main_body
  # Constants
  # Post Status
  STATUS_PENDING = 0
  STATUS_NORMAL = 1
  STATUS_DELETED = 2

  # Post Privilege
  PRIVILEGE_PUBLIC = 0
  PRIVILEGE_PRIVATE = 1

  # Post Type
  TYPE_TALK = 0
  TYPE_SUBJECT = 1
  TYPE_RECOMMEND = 2

  # Callbacks
  after_initialize :default_values
  before_save :add_exp, :add_post_count
  after_create :save_image # just for creating a talk

  # Associations
  belongs_to :creator, class_name: 'Account', foreign_key: 'account_id', inverse_of: :posts
  delegate :nick_name, :avatar, :level, to: :creator, prefix: true
  has_many :accounts_like_posts
  has_many :likers, through: :accounts_like_posts, source: :account
  has_many :comments, class_name: 'Comment'
  #has_many :recommend_posts, class_name: 'Recommend', foreign_key: 'parent_id'
  belongs_to :group, inverse_of: :posts
  has_many :post_images

  has_one :image, class_name: 'PostImage', foreign_key: 'post_id'
  delegate :url, to: :image, prefix: true

  has_one :tipoff, as: :detail

  # Recommend Association
  belongs_to :original, class_name: 'Post', foreign_key: 'original_id'
  delegate :content, :title, :creator, :image_url, to: :original, prefix: true
  belongs_to :parent, class_name: 'Post', foreign_key: 'parent_id'
  belongs_to :original_author, class_name: 'Account', foreign_key: 'original_author_id'

  # Validations
  validates :privilege, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: self::PRIVILEGE_PRIVATE }
  validates :status, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: self::STATUS_DELETED }
  validates :post_type, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :comment_count, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :recommend_count, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :like_count, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :creator, presence: true
  validates :content, length: { maximum: 140, message: I18n.t("post.content_is_too_long") }, allow_blank: true
  validates :main_body, presence: true, if: Proc.new { |a| a.status != Post::STATUS_PENDING && a.post_type == Post::TYPE_SUBJECT }
  validate :group_should_be_added
  validate :only_one_pending_post

  # Scopes
  scope :recommend_posts_with_account, lambda { |post_id| where("original_id=? AND status=?", post_id, Post::STATUS_NORMAL).includes(:creator).order("created_at DESC") }

  scope :talk_type, where(post_type: self::TYPE_TALK)
  scope :subject_type, where(post_type: self::TYPE_SUBJECT)
  scope :recommend_type, where(post_type: self::TYPE_RECOMMEND)
  scope :pending, where(status: self::STATUS_PENDING)
  scope :all_public, where(status: self::STATUS_NORMAL)
  scope :includes_for_a_stream, includes([:image, :creator, original: [:image]])

  # Methods
  class << self
    def for_a_stream(min_id, order, user)
      # TODO: add visible(public/private) here
      min_id > 0 ? where("posts.id < ?", min_id).order(order).includes_for_a_stream : order(order).includes_for_a_stream
    end
  end

  def is_talk?
    self.post_type == self.class::TYPE_TALK
  end

  def is_subject?
    self.post_type == self.class::TYPE_SUBJECT
  end

  def is_recommend?
    self.post_type == self.class::TYPE_RECOMMEND
  end

  def is_deleted?
    self.status == self.class::STATUS_DELETED
  end

  def is_normal?
    self.status = self.class::STATUS_NORMAL
  end

  def cloud_storage_id=(value)
    @cloud_storage_id = value.to_i
  end

  def add_a_image!(image)
    if image.is_a?(Fixnum)
      cloud_storage = CloudStorage.find(image)
      return false unless cloud_storage
      post_image = PostImage.new
      post_image.post_id = self.id
      post_image.cloud_storage = cloud_storage
      post_image.save!
      post_image
    elsif image.is_a?(String)
      raise "TO BE DONE"
    else
      raise "Error image"
    end
  end

  def post_pending
    raise "Post pending is used for a subject post" if self.post_type != Post::TYPE_SUBJECT
    if self.status == Post::STATUS_PENDING
      self.status = Post::STATUS_NORMAL
      @post_pending_subject = true
      if self.save
        @post_pending_subject = false
        true
      else
        @post_pending_subject = false
        false
      end
    else
      false
    end
  end

  protected
  def default_values
    self.status ||= self.class::STATUS_NORMAL
    self.privilege ||= self.class::PRIVILEGE_PUBLIC
    self.comment_count ||= 0
    self.recommend_count ||= 0
    self.like_count ||= 0
    #self.post_type ||= self.class::TYPE_TALK
  end

  def add_exp
    case self.post_type
    when self.class::TYPE_TALK
      Sonkwo::Exp.increase("exp_post_talk", self.creator, self.created_at) if self.new_record?
    when self.class::TYPE_RECOMMEND
      Sonkwo::Exp.increase("exp_recommend_post", self.creator, self.created_at) if self.original && self.original_creator != self.creator if self.new_record?
    when self.class::TYPE_SUBJECT
      return true if self.status == self.class::STATUS_PENDING
      Sonkwo::Exp.increase("exp_post_subject", self.creator, self.created_at) if self.new_record? || @post_pending_subject
    else
      raise "Unknow type"
    end
  end

  def add_post_count
    case self.post_type
    when self.class::TYPE_TALK
      if self.new_record?
        self.creator.talk_count += 1
        self.creator.save!
        if self.group
          self.group.talk_count += 1
          self.group.save!
        end
      end
    when self.class::TYPE_SUBJECT
      return true if self.status == self.class::STATUS_PENDING
      if self.new_record? || @post_pending_subject
        self.creator.subject_count += 1
        self.creator.save!
        if self.group
          self.group.subject_count += 1
          self.group.save!
        end
      end
    when self.class::TYPE_RECOMMEND
      if self.parent
        self.creator.recommend_count += 1
        self.parent.recommend_count += 1
        self.parent.save!
        if self.original.id != self.parent.id
          self.original.recommend_count += 1
          self.original.save!
        end
        self.creator.save!
      end
    else
      raise "Unknow type"
    end
  end

  def save_image
    return true if self.post_type != self.class::TYPE_TALK
    self.add_a_image!(@cloud_storage_id) if @cloud_storage_id && @cloud_storage_id != 0
    true
  end

  def group_should_be_added
    if self.group && self.creator && !self.group.accounts.include?(self.creator)
      errors.add(:group, I18n.t("models.post.error_group_not_added"))
    end
  end

  def only_one_pending_post
    return unless self.creator
    pending_item = self.class.where(account_id: self.creator.id, status: self.class::STATUS_PENDING).first
    if pending_item && self.status == self.class::STATUS_PENDING && self.id != pending_item.id
      errors[:base] << I18n.t("post.more_than_one_pending_post")
    end
  end
end
