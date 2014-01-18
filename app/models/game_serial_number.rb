require 'base32/crockford'
class GameSerialNumber < ActiveRecord::Base
  attr_accessible :batch_number, :serial_type, :serial_status, :serial_number, :status, :game_id
  belongs_to :game
  belongs_to :serialtype, class_name: "SerialType", foreign_key: "serial_type"
  
  STATUS_FRESH      = 0
  STATUS_ALLOCATED  = 2
  STATUS_USED       = 1
  STATUS_ALL        = 3 # FOR localization

  def create_product_keys!(other)
    prefix = other[:prefix]
    partner_code = other[:partner_code]
    count = other[:count]
    prefix_str = ''

    if prefix && prefix.match(/\w{4}/)
      prefix_str << prefix
    else
      self.errors[:base] << I18n.t('admin.errors.prefix_invalid')
      return
    end

    prefix_str << self.batch_number.to_s(36).upcase
    prefix_str << '-'

    type_dic = {TYPE_ONLINE_PRODUCT_KEY: 'NP', TYPE_OFFLINE_PRODUCT_KEY: 'CP', TYPE_RETAIL_PRODUCT_KEY: 'RP', TYPE_TRAIL_PRODUCT_KEY: 'TP'}
    serial_type = self.serialtype.type_name.to_sym

    if (type_dic.keys.include?(serial_type))
      prefix_str << type_dic[serial_type]
    else
      self.errors[:base] << I18n.t('admin.errors.product_key_type_invalid')
      raise I18n.t('admin.errors.product_key_type_invalid')
    end

    if partner_code && ('A'..'Z').include?(partner_code)
      prefix_str << partner_code
    else
      self.errors[:base] << I18n.t('admin.errors.partner_code_invalid')
      return
    end

    prefix_str << Base32::Crockford.encode(Time.now.to_i, :split=>5, :length=>7)

    serial_numbers = []
    count.to_i.times do 
      random_arr = Base32::Crockford.encode(rand(10**15), :split=>5, :length=>10)
      serial_number = [prefix_str, random_arr].join('-')
      self.serial_number = serial_number
      self.status = STATUS_FRESH
      serial_numbers << self.attributes.reject!{|k, v| v == nil }
    end

    GameSerialNumber.create(serial_numbers)
    return true
  end
end
