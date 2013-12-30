module AdminHelper
  ALERT_TYPES = [:danger, :info, :success, :warning]

  def sonkwo_flash
    flash_messages = []
    flash.each do |type, message|
      # Skip empty messages, e.g. for devise messages set to nothing in a locale file.
      next if message.blank?

      type = :success if type == :notice
      type = :danger   if type == :alert
      next unless ALERT_TYPES.include?(type)

      Array(message).each do |msg|
        text = content_tag(:div,
                           content_tag(:button, raw("&times;"), :class => "close", "data-dismiss" => "alert") +
                               msg.html_safe, :class => "alert fade in alert-#{type}")
        flash_messages << text if msg
      end
    end
    flash_messages.join("\n").html_safe
  end

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
