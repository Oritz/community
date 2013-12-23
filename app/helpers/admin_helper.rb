module AdminHelper
  def sonkwo_time_format(time)
    return time.to_formatted_s(:db)
  end
  STATUS_NEW         = 0
  STATUS_TO_VERIFY   = 1
  STATUS_VALIDATED   = 2
  STATUS_REJECTED    = 3
  STATUS_CANCELED    = 4
  STATUS_ROLLBACKED  = 5
  def tr_with_status(status)
    red_status = [GameFile::STATUS_REJECTED, GameFile::STATUS_CANCELED, GameFile::STATUS_ROLLBACKED]
    green_status = [GameFile::STATUS_NEW, GameFile::STATUS_TO_VERIFY]

    if red_status.include?(status)
      return 'error'
    elsif green_status.include?(status)
      return 'success'
    end
  end

  class SelectFromLocal
    attr_accessor :content, :value
  end

  def select_from_local_arrary(local_array)
    select_arrary = []
    local_array.each do |a|
      sfl = SelectFromLocal.new
      sfl.content = a
      sfl.value = local_array.index(a)
      select_arrary << sfl
    end

    return select_arrary
  end
end
