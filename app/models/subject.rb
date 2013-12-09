require 'sonkwo/exp'

class Subject < ActiveRecord::Base
  attr_accessible :title, :content

  acts_as_post
  #acts_as_behavior_provider author_key: "posts.account_id",
  #  timestamp: "posts.created_at",
  #  status: "posts.status",
  #  joins: "INNER JOIN posts ON posts.id=subjects.id",
  #  find_options: {include: [post: [:creator]]}
  acts_as_api
  api_accessible :post_info do |t|
    t.add :creator
    t.add :id
    t.add :post_type
    t.add :comment_count
    t.add :recommend_count
    t.add :like_count
    t.add :created_at
    t.add :updated_at
    t.add :content
    t.add :title
  end
  #exp_hookable account: "self.creator", setting_name: "exp_subject_value"

  # Callbacks
  after_initialize :default_values
  before_create :add_subject_count
  #before_create :check_group, :add_subject_count
  after_create { Sonkwo::Exp.increase("exp_post_subject", self.creator, self.created_at) }

  # Validations
  validates :content, presence: true
  validates :title, presence: true, length: { maximum: 64 }

  # Associations
  #belongs_to :group

  # Scopes
  #scope :sort_by_time_in_group, lambda { |group_id| where("group_id=? AND status=?", group_id, Post::STATUS_NORMAL).includes(post: [:creator]).order("posts.created_at DESC") }
  #scope :sort_by_like_in_group, lambda { |group_id| where("group_id=? AND status=?", group_id, Post::STATUS_NORMAL).includes(post: [:creator]).order("posts.like_count DESC") }
  #scope :sort_by_comment_in_group, lambda { |group_id| where("group_id=? AND status=?", group_id, Post::STATUS_NORMAL).includes(post: [:creator]).order("posts.comment_count DESC") }
  #scope :subjects_in_groups_added, lambda { |account_id, subject_count| joins("INNER JOIN posts ON posts.id=subjects.id INNER JOIN groups_accounts ON groups_accounts.group_id=subjects.group_id").where("groups_accounts.account_id=? AND posts.status=?", account_id, Post::STATUS_NORMAL).order("posts.created_at DESC").limit(subject_count).includes([:post, :group]) }

  # Methods
  private
  def default_values
    unless self.id
      self.post = Post.new
      self.post_type = Post::TYPE_SUBJECT
    end
  end

  def add_subject_count
    self.creator.subject_count += 1
    self.creator.save!
  end

  #def check_group
  #  if self.group && !self.creator.groups.include?(self.group)
  #    errors.add(:group, I18n.t("activemodel.errors.models.subject.attributes.group.not_belong_to"))
  #    false
  #  end
  #end
end
