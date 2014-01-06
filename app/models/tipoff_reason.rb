class TipoffReason < ActiveRecord::Base
  attr_accessible :name

  # Validates
  validates :name, presence: true, length: { in: 2..255 }, uniqueness: { case_sensitive: false, message: I18n.t("tipoff_reason.name_is_used") }
end
