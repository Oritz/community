class SerialFile
  def initialize(serial_params, serial_file)
    @serial_type = serial_params[:serial_type].to_i
    serial_params.delete('serial_type')
    @serial_params = serial_params
    @serial_file = serial_file
  end

  def file_valid?
    return I18n.t("ERRORS.ERROR_HAVE_NOT_CHOOSE_A_SERIAL_FILE") unless @serial_file
    file_type = @serial_file.content_type.chomp
    return I18n.t("ERRORS.ERROR_INVALID_FILE_FORMAT") unless file_type == 'text/plain'
    return I18n.t("ERRORS.ERROR_INVALID_SERIAL_STATUS") if @serial_params[:serial_status].to_i < 0 || @serial_params[:serial_status].to_i >= GameSerialNumber::STATUS_ALL
    true
  end

  def import!
    serial_numbers = []
    File.open(@serial_file.tempfile, 'r').each_line do |line|
      serial_number = @serial_params.merge({serial_number: line.strip, status: GameSerialNumber::STATUS_FRESH})
      serial_numbers << serial_number
    end
    serial_type = SerialType.find(@serial_type)
    serial_type.game_serial_numbers.create!(serial_numbers)
  end
end