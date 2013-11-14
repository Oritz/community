class Conversation < ActiveRecord::Base
  # Association
  belongs_to :first_account, class_name: 'Account', foreign_key: 'first_account_id'
  belongs_to :second_account, class_name: 'Account', foreign_key: 'second_account_id'
  has_many :private_messages

  # Callbacks
  before_create :check_talkers

  # Methods
  private
  def check_talkers
    return false unless self.first_account && self.second_account
    return false if self.first_account.id >= self.second_account.id
    true
  end
end
