class SerialType < ActiveRecord::Base
  TYPE_PUBLIC       = 0
  TYPE_PRIVATE      = 1
  TYPE_BASIC        = 2
  attr_accessible :type_cat, :type_desc, :type_name
  has_many :game_serial_numbers, foreign_key: 'serial_type'

  protected
  def default_values
    self.type_cat ||= self.class::TYPE_PRIVATE if self.attribute_names.include?('type_cat')
  end
end
