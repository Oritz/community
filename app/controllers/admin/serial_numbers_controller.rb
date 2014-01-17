require 'common/serial_number_file'
class Admin::SerialNumbersController < AdminController
  def index
    game_id = params[:game_id]
    @game = Game.find(game_id)

    @q = GameSerialNumber.search(params[:q])
    @game_serial_numbers = @q.result.where('game_id =?', game_id).page(params[:page]).per(10)

    @serial_number_types = []
    (0..(GameSerialNumber.human_attribute_name(:status_arr).size-1)).each do |i|
      temp_status = GameSerialNumber.select('status, count(*) as number, serial_type').includes(:serialtype).where('game_id=? AND status=?', game_id, i).group('serial_type').all
      temp_status.each do |item|
        number = @serial_number_types[item.serialtype.id] ? @serial_number_types[item.serialtype.id][:number] : []
        number[i] = item.number || 0
        @serial_number_types[item.serialtype.id] = {:type_name => item.serialtype.type_name, :type_desc => item.serialtype.type_desc, :number => number}
      end
    end

    @serial_number_counts = GameSerialNumber.select('status, count(*) AS totalcount').where('game_id=?', game_id).group('status').all

    #import serial_numbers
    @serial_types = SerialType.select('serial_types.id, type_name').joins('LEFT JOIN game_serial_types AS gt ON gt.serial_type = serial_types.id').where('type_cat=? or game_id=?', SerialType::TYPE_BASIC, game_id).group('serial_types.id')
    @serial_type = SerialType.new
    @serial_type.type_cat = SerialType::TYPE_PRIVATE

    respond_to do |format|
      format.html # index.html.slim
      format.xml  { render :xml => @admin_serial_numbers }
    end
  end

  def import
    if request.post?
      serial_file = SerialFile.new(params[:serial_number], params[:serial_file])
      if serial_file.file_valid? == true
        serial_file.import!
        flash[:notice] = t('admin.msg.success')
      else
        flash[:alert] = serial_file.file_valid?
      end
      redirect_to admin_game_serial_numbers_path
    end
  end

  def delete_selection
    game_id = params[:game_id]
    @delete_form = Admin::GameSerialNumberDeleteForm.new(:game_id => game_id)
    @game = Game.find(game_id)

    respond_to do |format|
      format.html
    end
  end

  def delete_serials
    @game = Game.find(params[:game_id])
    form_data = params[:admin_game_serial_number_delete_form]
    @delete_form = Admin::GameSerialNumberDeleteForm.new(form_data)

    game_id = params[:admin_game_serial_number_delete_form][:game_id]
    @game = Game.find(game_id)

    if @delete_form.valid?
      ActiveRecord::Base.transaction do
        @all_count = GameSerialNumber.where("game_id=? AND batch_number=? AND serial_type=? AND created_at>=? AND created_at<=?", @delete_form.game_id, @delete_form.batch_number, @delete_form.serial_type, @delete_form.start_time, @delete_form.end_time).count
        @used_count = GameSerialNumber.where("status<>? AND game_id=? AND batch_number=? AND serial_type=? AND created_at>=? AND created_at<=?", GameSerialNumber::STATUS_FRESH, @delete_form.game_id, @delete_form.batch_number, @delete_form.serial_type, @delete_form.start_time, @delete_form.end_time).count
        GameSerialNumber.destroy_all(["status=? AND game_id=? AND batch_number=? AND serial_type=? AND created_at>=? AND created_at<=?", GameSerialNumber::STATUS_FRESH, @delete_form.game_id, @delete_form.batch_number, @delete_form.serial_type, @delete_form.start_time, @delete_form.end_time])
      end
      flash[:notice] = t('admin.msg.success')
    else
      flash[:error] = t('admin.serial.delete_failed')
    end
    
    redirect_to admin_game_serial_numbers_path(@game)
  end

end
