require 'sonkwo/exp'

class Subject < ActiveRecord::Base
  attr_accessible :title, :content

  acts_as_polymorphic class_name: 'Post', name: 'detail', association: 'post'
  #acts_as_post
  #acts_as_behavior_provider author_key: "posts.account_id",
  #  timestamp: "posts.created_at",
  #  status: "posts.status",
  #  joins: "INNER JOIN posts ON posts.id=subjects.id",
  #  find_options: {include: [post: [:creator]]}
  acts_as_api
  api_accessible :post_info do |t|
    t.add :creator
    t.add :id
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
  before_save :add_subject_count, :add_exp

  # Validations
  validates :content, presence: true, if: Proc.new { |a| a.status != Post::STATUS_PENDING }
  validates :title, presence: true, length: { maximum: 64 }, if: Proc.new { |a| a.status != Post::STATUS_PENDING }

  # Associations
  #belongs_to :group
  has_one :post, as: :detail

  # Scopes
  scope :pending_of_account, lambda { |account| joins("INNER JOIN posts ON posts.id=subjects.id").where("account_id=? AND status=?", account.id, Post::STATUS_PENDING) }
  #scope :sort_by_time_in_group, lambda { |group_id| where("group_id=? AND status=?", group_id, Post::STATUS_NORMAL).includes(post: [:creator]).order("posts.created_at DESC") }
  #scope :sort_by_like_in_group, lambda { |group_id| where("group_id=? AND status=?", group_id, Post::STATUS_NORMAL).includes(post: [:creator]).order("posts.like_count DESC") }
  #scope :sort_by_comment_in_group, lambda { |group_id| where("group_id=? AND status=?", group_id, Post::STATUS_NORMAL).includes(post: [:creator]).order("posts.comment_count DESC") }
  #scope :subjects_in_groups_added, lambda { |account_id, subject_count| joins("INNER JOIN posts ON posts.id=subjects.id INNER JOIN groups_accounts ON groups_accounts.group_id=subjects.group_id").where("groups_accounts.account_id=? AND posts.status=?", account_id, Post::STATUS_NORMAL).order("posts.created_at DESC").limit(subject_count).includes([:post, :group]) }

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

  #def check_group
  #  if self.group && !self.creator.groups.include?(self.group)
  #    errors.add(:group, I18n.t("activemodel.errors.models.subject.attributes.group.not_belong_to"))
  #    false
  #  end
  #end
end
