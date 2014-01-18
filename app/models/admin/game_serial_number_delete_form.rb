# -*- encoding : utf-8 -*-
require "active_form"

class Admin::GameSerialNumberDeleteForm < ActiveForm
  attr_accessor :batch_number, :start_time, :end_time, :game_id, :serial_type

  validates :batch_number, :presence => true, :numericality => { :greater_than => -1 }
  validates :serial_type, :presence => true, :numericality => { :greater_than => -1 }
  validates :start_time, :presence => true
  validates :end_time, :presence => true
  validates :game_id, :presence => true

  def batch_numbers
    tmps = GameSerialNumber.where(["game_id=?", @game_id]).select("DISTINCT(batch_number)")
    tmps.collect{ |t| t.batch_number }
  end

  def serial_types
    game_serial_types = SerialType.joins("LEFT JOIN game_serial_types ON serial_type=serial_types.id").where(["game_id=? or type_cat=?", @game_id, SerialType::TYPE_BASIC]).select("serial_types.id, type_name")

    serial_types = [] 
    game_serial_types.collect do |t|
      serial_types << [t.type_name, t.id]
    end
    serial_types
  end
end
