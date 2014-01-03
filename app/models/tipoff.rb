class Tipoff < ActiveRecord::Base
  # Constants
  STATUS = {
    undealt: 0,
    dealted: 1,
    closed: 2
  }

  # Callbacks
  after_initialize :default_values

  # Associations
  belongs_to :account
  belongs_to :censor, class_name: "Account", foreign_key: "censor_id"
  belongs_to :detail, polymorphic: true
  belongs_to :reason, class_name: "TipoffReason", foreign_key: "reason_id"
  belongs_to :target, class_name: "Account", foreign_key: "target_account_id"

  # Validations
  validates :account, presence: true
  validates :detail, presence: true
  validates :reason, presence: true
  validates :account_id, uniqueness: { scope: [:detail_type, :detail_id], message: I18n.t("tipoff.already_tipoff") }

  # Methods
  protected
  def default_values
    self.status ||= self.class::STATUS[:undealt] if self.attribute_names.include?("status")
  end
end
