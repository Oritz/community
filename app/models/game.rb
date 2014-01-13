class Game < ActiveRecord::Base
  STATUS_NORMAL = 1
  TYPE_GAME = 1
  belongs_to :parent, class_name: "Game", foreign_key: "parent_id"
  has_many :game_files
  has_many :game_serial_numbers
  has_many :recommendations, foreign_key: 'link'
  scope :no_releases, -> {select('id, title, alias_name').includes(:game_files).where(:game_files =>{:game_id => nil})}

  def serial_type_arr=(arr)
    # puts "publisher_arr=#{arr}"

    @serial_type_arr = arr
    #@serial_type_arr = []

    #arr.each do |be_bit|
    #  if be_bit[1] == "1"
    #    @serial_type_arr.push(be_bit[0].to_i)
    #  end
    #end
  end

  def serial_type_arr
    if @serial_type_arr == nil
      @serial_type_arr = []
    end

    @serial_type_arr
  end
end
