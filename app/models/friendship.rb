require 'sonkwo/exp'

class Friendship < ActiveRecord::Base
  #acts_as_notificable callbacks: ["after_create"], slot: "followed", tos: ["account"]
  # Constants
  IS_SINGLE = 0
  IS_MUTUAL = 1
  FOLLOWER = 0
  FOLLOWING = 1
  MUTUAL = 2
  IS_SELF = 3

  self.primary_keys = [:account_id, :follower_id]
  # Associations
  belongs_to :follower, class_name: 'Account', foreign_key: 'follower_id'
  belongs_to :account

  # Callbacks
  before_create :add_relation
  after_create { Sonkwo::Exp.increase("exp_add_a_follower", self.account, self.created_at) }
  before_destroy :delete_relation
  after_initialize :default_values

  # Validations
  validates :account_id, uniqueness: { scope: :follower_id, message: I18n.t("activemodel.errors.models.friendship.attributes.account_id.uniqueness") }

  # Scopes
  scope :between_two_users, lambda { |visitor, *master_ids| true }

  # Methods
  private
  def default_values
    self.is_mutual ||= false
  end

  def add_relation
    return false if self.account.id == self.follower.id
    @backward = self.class.where("account_id=? AND follower_id=?", self.follower.id, self.account.id).first
    if @backward
      self.is_mutual = true
      @backward.is_mutual = true
      @backward.save!
    end

    self.account.follower_count += 1
    self.account.save!
    self.follower.following_count += 1
    self.follower.save!
  end

  def delete_relation
    return false if self.account.id == self.follower.id
    @backward = self.class.where("account_id=? AND follower_id=?", self.follower.id, self.account.id).first
    if @backward
      @backward.is_mutual = false
      @backward.save!
    end

    self.account.follower_count -= 1 if self.account.follower_count > 0
    self.account.save!
    self.follower.following_count -= 1 if self.follower.following_count > 0
    self.follower.save!
  end
end
