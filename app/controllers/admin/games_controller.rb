# -*- coding: utf-8 -*-
require 'uuidtools'
#require 'common/workflow_service'
class Admin::GamesController < AdminController
  def index
    @q = GameFile.search(params[:q])
    @games = @q.result.page(params[:page]).per(10)
    @not_released_games = Game.no_releases.page(params[:un_release_page]).per(10)

    respond_to do |format|
      format.html # index.html.slim
      format.xml  { render :xml => @admin_games }
    end
  end

  # DELETE /admin_games/1
  # DELETE /admin_games/1.xml
  def destroy
    @game = Game.find(params[:id])
    form_data = params[:admin_game_serial_number_delete_form]
    #start_time = Time.parse(form_data[:start_time])
    #end_time = Time.parse(form_data[:end_time])

    @delete_form = Admin::GameSerialNumberDeleteForm.new(form_data)

    game_id = params[:admin_game_serial_number_delete_form][:game_id]
    @game = Game.find(game_id)

    if @delete_form.valid?
      ActiveRecord::Base.transaction do
        @all_count = GameSerialNumber.where("game_id=? AND batch_number=? AND serial_type=? AND created_at>=? AND created_at<=?", @delete_form.game_id, @delete_form.batch_number, @delete_form.serial_type, @delete_form.start_time, @delete_form.end_time).count
        @used_count = GameSerialNumber.where("status<>? AND game_id=? AND batch_number=? AND serial_type=? AND created_at>=? AND created_at<=?", GameSerialNumber::STATUS_FRESH, @delete_form.game_id, @delete_form.batch_number, @delete_form.serial_type, @delete_form.start_time, @delete_form.end_time).count
        GameSerialNumber.destroy_all(["status=? AND game_id=? AND batch_number=? AND serial_type=? AND created_at>=? AND created_at<=?", GameSerialNumber::STATUS_FRESH, @delete_form.game_id, @delete_form.batch_number, @delete_form.serial_type, @delete_form.start_time, @delete_form.end_time])
      end
    else
      flash[:error] = t('admin.serial.delete_failed')
    end
    flash[:notice] = t('admin.msg.success')
    redirect_to game_serial_numbers_admin_game_path(@game)
  end


  def search
    @admin_games = Game.where("title like ?", "%#{params[:query]}%").page(params[:page]).per(10)
    render :index
  end

  def pre_release_list
    id = params[:id]
    @game = Game.find(id)
    @prev_game_files = GameFile.where('game_id=?', id).order('created_at DESC').limit(10)

    respond_to do |format|
      format.html
      format.xml  { render :xml => @prev_game_files }
    end
  end

  def new_pre_release
    game_id = params[:id]

    game_shell = params[:game_shell]
    game_ini = params[:game_ini]
    file_dir = params[:file_dir]
    crypt_type = params[:crypt_type]
    exe_path_name = params[:exe_path_name]

    @game = Game.find(game_id)
    @have_released = GameFile.select('id').where('game_id=? AND (status =? OR status = ?)', game_id, GameFile::STATUS_NEW, GameFile::STATUS_TO_VERIFY).first
    @prev_game_files = GameFile.where('game_id=?', game_id).order('created_at DESC')
    @game_file = @game.game_files.new

    @crypt_types = []
    i=0
    t('admin.game.crypt_types').each do |sta|
      @crypt_types << [sta, i]
      i += 1
    end

    begin
      socket = TCPSocket.new(Settings.sys_params.file_server_host, Settings.sys_params.file_server_port)
      socket.puts("LIST_DIR##{@game.alias_name}")
      dirs_json = socket.gets
      socket.close     
    rescue Exception => e
      raise e.inspect + t('admin.errors.could_not_conect_to_release_server')
    end


    @release_dirs = ActiveSupport::JSON.decode(dirs_json)

    prev_valideted_game_files = GameFile.where('game_id=? AND status=?', game_id, GameFile::STATUS_VALIDATED).order('created_at DESC')

    @release_dirs.delete("initial") unless prev_valideted_game_files.empty?

    if request.post?
      ActiveRecord::Base.transaction do
        if !game_ini && !game_shell && !crypt_type
          @game_file.errors[:base] << t('admin.err.release_content_missing')
          return
        end

        @game_file.game_id = game_id
        latest_game_file = GameFile.where('game_id=?', game_id).order('created_at DESC').lock('LOCK IN SHARE MODE').first

        if latest_game_file
          prev_ini_ver = latest_game_file.ini_ver
          prev_shell_ver = latest_game_file.shell_ver
          prev_patch_ver = latest_game_file.patch_ver
        else
          prev_ini_ver = 0
          prev_shell_ver = 0
          prev_patch_ver = -1
        end

        if game_shell
          @game_file.game_shell = game_shell.read
          @game_file.shell_digest = Digest::SHA1.hexdigest(@game_file.game_shell)
          @game_file.shell_ver = prev_shell_ver + 1
        elsif latest_game_file
          @game_file.game_shell = latest_game_file.game_shell
          @game_file.shell_digest = latest_game_file.shell_digest
          @game_file.shell_ver = prev_shell_ver
        else
          @game_file.errors[:base] << t('admin.err.game_shell_not_exist')
        end

        if game_ini
          @game_file.game_ini = game_ini.read
          @game_file.ini_digest = Digest::SHA1.hexdigest(@game_file.game_ini)
          @game_file.ini_ver = prev_ini_ver + 1
        elsif latest_game_file
          @game_file.game_ini = latest_game_file.game_ini
          @game_file.ini_digest = latest_game_file.ini_digest
          @game_file.ini_ver = prev_ini_ver
        else
          @game_file.errors[:base] << t('admin.err.game_ini_not_exist')
        end


        if file_dir
          if file_dir.strip.length == 0
            @game_file.errors[:base] << t('admin.err.game_dir_not_specified')
          end

          @game_file.file_dir = file_dir
          @game_file.crypt_type = crypt_type

          if crypt_type.to_i != Launcher::CRYPT_TYPE_EXTERNAL
            if exe_path_name == nil || exe_path_name.strip.length == 0
              @game_file.errors[:base] << t('admin.err.game_exe_not_specified')
            else
              @game_file.exe_path_name = exe_path_name
            end
          else
            @game_file.exe_path_name = ""
          end

          @game_file.patch_ver = prev_patch_ver + 1
          @game_file.status = GameFile::STATUS_NEW
        elsif latest_game_file
          @game_file.file_dir = latest_game_file.file_dir
          @game_file.crypt_type = latest_game_file.crypt_type
          @game_file.exe_path_name = latest_game_file.exe_path_name

          @game_file.game_key = latest_game_file.game_key
          @game_file.game_key_iv = latest_game_file.game_key_iv
          @game_file.key_digest = latest_game_file.key_digest

          @game_file.launcher_ver = latest_game_file.launcher_ver
          @game_file.patch_ver = prev_patch_ver
          @game_file.seed_content = latest_game_file.seed_content
          @game_file.seed_digest = latest_game_file.seed_digest
          @game_file.file_size = latest_game_file.file_size
          @game_file.status = GameFile::STATUS_TO_VERIFY
        else
          @game_file.errors[:base]  << t('admin.err.game_dir_not_specified')
        end


        if @game_file.errors.size == 0
          @game_file.save!
          Admin::PreReleaseWorker.perform_async(@game_file.id) if file_dir
          redirect_to pre_release_list_admin_game_path(game_id), notice: t('admin.msg.success')
        end
      end
    end
  end

  def cancel_pre_release
    if request.post?
      game_id = params[:id]
      game_file_id = params[:game_file_id]

      ActiveRecord::Base.transaction do
        game_file = GameFile.find(game_file_id, lock: true)

        if !game_file
          err = t('admin.err.game_file_not_exist')
        else
          game = Game.find(game_id)

          flow_status = {}
          flow_status[GameFile::STATUS_NEW] = "STATUS_NEW"
          flow_status[GameFile::STATUS_TO_VERIFY] = "STATUS_TO_VERIFY"

          if game_file.status != GameFile::STATUS_NEW && game_file.status != GameFile::STATUS_TO_VERIFY

          else
            #new_status, rcpt, cc, msg_title, msg_body = WorkflowService.process("release_game", flow_status[game_file.status], "on_cancel", {:game_name => game.title, :game_file_id => game_file.id})
            game_file.status = GameFile::STATUS_CANCELED   #eval("GameFile::#{new_status}")
            game_file.save!

            #flow_err = WorkflowService.send_notification(rcpt, cc, msg_title, msg_body)
            # raise ActiveRecord::Rollback if flow_err
          end

          if err
            flash[:error] = err
          else
            flash[:notice] = "Successfully canceled."
          end

          redirect_to pre_release_list_admin_game_path(game_file.game_id)
          return
        end
      end
    end
  end

  def get_exe_files
    socket = TCPSocket.new(Settings.sys_params.file_server_host, Settings.sys_params.file_server_port)
    socket.puts("LIST_EXE##{params[:game_name]}##{params[:file_dir]}")

    exes_json = socket.gets
    socket.close

    render :json => exes_json
  end

  def release_search
    @release_to_audit_cnt = GameFile.status_to_verify.count
    @release_to_audit_cnts = GameFile.select('status, COUNT(id) AS release_count').group('status')
    @select_options = []
    i=0

    t('admin.game.audit_status').each do |sta|
      @select_options << [sta, i]
      i += 1
    end

    @search_reault = nil


    conditions = ['title LIKE ?', params[:game_name]]

    if params[:audit_status] != "-1"
      conditions[0] += ' AND game_files.status=?'
      conditions << params[:audit_status]
    end

    @search_reault = Game.joins(:game_files).where(conditions).paginate(
        :select=>"game_files.id, game_id, title, created_at, crypt_type, file_dir, exe_path_name, process_start_time, process_finish_time, process_result, ini_ver, shell_ver, patch_ver, game_files.status, created_at",
        :order=>"created_at DESC",
        :per_page => 10,
        :page => params[:page]
    )

    # render :layout => false
  end


  def audit_release
    err = nil
    game_id = params[:id]
    @game = Game.select('id, title').where('id = ?', game_id).first
    game_file_id = params[:game_file_id]
    new_status = params[:new_status]
    comment = params[:comment]

    @new_status = new_status.to_i
    if request.get?
      status = case @new_status
                 when GameFile::STATUS_VALIDATED, GameFile::STATUS_REJECTED
                   GameFile::STATUS_TO_VERIFY
                 when GameFile::STATUS_ROLLBACKED
                   GameFile::STATUS_VALIDATED
               end

      @game_file = GameFile.select('id, created_at, crypt_type, file_dir, exe_path_name, process_start_time, process_finish_time, process_result, ini_ver, shell_ver, patch_ver, status').where('id=? AND status =?', game_file_id, status).first
      unless @game_file
        flash[:error] = t('admin.errors.game_file_not_exist')
      end
    elsif request.post?
      ActiveRecord::Base.transaction do
        case @new_status
          when GameFile::STATUS_VALIDATED
            game_file = GameFile.lock(true).where('id=? AND status=?', game_file_id, GameFile::STATUS_TO_VERIFY).first

            not_null_fields = []
            unless game_file
              err = t('admin.errors.game_file_not_exist')
            else
              not_null_fields = [game_file.seed_content, game_file.seed_digest, game_file.file_size]
              if game_file.crypt_type != Launcher::CRYPT_TYPE_EXTERNAL
                not_null_fields.join(game_file.game_key)
                not_null_fields.join(game_file.game_key_iv)
                not_null_fields.join(game_file.key_digest)
                not_null_fields.join(game_file.launcher_ver)
              end

              not_null_fields.each do |n|
                if !n
                  err = t('admin.errors.game_fields_missing')
                end
              end

              unless err
                previous_release = GameFile.lock(true).where('game_id=? AND created_at < ? AND (status=? OR status=?)', game_file.game_id, game_file.created_at, GameFile::STATUS_NEW, GameFile::STATUS_TO_VERIFY)
                previous_release.each do |p|
                  p.status = GameFile::STATUS_CANCELED
                  p.save!
                end


                #game = Game.find(game_file.game_id).select('title')
                #new_flow_status , rcpt, cc, msg_title, msg_body = WorkflowService.process("release_game", "STATUS_TO_VERIFY", "on_pass", {:game_name => game.title, :game_file_id => game_file.id})
                game_file.status =  GameFile::STATUS_VALIDATED #eval("GameFile::#{new_flow_status}")
                game_file.save!

                #flow_err = WorkflowService.send_notification(rcpt, cc, msg_title, msg_body)
                # raise ActiveRecord::Rollback if flow_err
              end
            end

          when GameFile::STATUS_REJECTED
            # 审核不通过
            game_file = GameFile.lock(true).where('id=? AND status=?', game_file_id, GameFile::STATUS_TO_VERIFY).first
            latest_game_file = GameFile.where('game_id=?', game_file.game_id).select('created_at').order('created_at DESC').first

            if !game_file
              err = t('admin.errors.game_file_not_exist')
            elsif comment == nil || comment.strip.length == 0
              err = t('admin.errors.audit_comment_missing')
            elsif game_file.created_at < latest_game_file.created_at
              err = t('admin.errors.history_release_canot_be_release')
            else
              #new_flow_status , rcpt, cc, msg_title, msg_body = WorkflowService.process("release_game", "STATUS_TO_VERIFY", "on_rejected", {:game_name => game.title, :game_file_id => game_file.id})
              game_file.status = GameFile::STATUS_REJECTED  #eval("GameFile::#{new_flow_status}")
              game_file.comment = comment
              game_file.save!

              #flow_err = WorkflowService.send_notification(rcpt, cc, msg_title, msg_body)
              # raise ActiveRecord::Rollback if flow_err
            end

          when GameFile::STATUS_ROLLBACKED
            game_file = GameFile.lock(true).where('id=? AND status=?', game_file_id, GameFile::STATUS_VALIDATED).first
            if !game_file
              err = t('admin.errors.game_file_not_exist')
            elsif comment == nil || comment.strip.length == 0
              err = t('admin.errors.audit_comment_missing')
            else
              #new_flow_status , rcpt, cc, msg_title, msg_body = WorkflowService.process("release_game", "STATUS_VALIDATED", "on_rollback", {:game_name => game.title, :game_file_id => game_file.id})

              game_file.status = GameFile::STATUS_ROLLBACKED #eval("GameFile::#{new_flow_status}")
              game_file.comment = comment
              game_file.save!

              #flow_err = WorkflowService.send_notification(rcpt, cc, msg_title, msg_body)
              # raise ActiveRecord::Rollback if flow_err
            end
          else
            err = t('admin.errors.invalid_release_status')
        end
      end
      redirect_to admin_games_path, :notice => t('admin.msg.success')
    end
  end

  def submit_release
    game_id = params[:id]
    @game = Game.select('id, title, alias_name').find(game_id)
    @download_servers = Admin::DownloadServer.all
    game_file = Game.includes(:game_files).where('games.id = ? AND (game_files.status = ? OR game_files.status =?)', game_id, GameFile::STATUS_TO_VERIFY, GameFile::STATUS_VALIDATED).order('game_files.created_at DESC').first
    unless game_file
      flash.now[:notice] = t('game_files_not_do_prelease')
    end

    if request.post?
      server_ids = params[:server_ids]

      server_ids.each do |server_id|
        Admin::PublishReleaseFilesWorker.perform_async(game_id, @game.alias_name, server_id)
      end
      #	TODO: 调用通知工具

      flash[:notice] = t('admin.msg.success')
    end
  end

  def game_serial_numbers
    query = params[:query] ? params[:query].gsub(/\s+/, "") : nil
    status = params[:status].to_i # 0: fresh 1: used 2: allocated
    game_id = params[:id]
    @game = Game.find(game_id)
    if query
      @admin_serial_numbers = GameSerialNumber.select(
        'id, serial_number, serial_type, status, created_at, updated_at'
      ).includes(:serial_type).where(
      "game_id=? AND serial_number LIKE ?", game_id, "%#{query}%"
      ).page(params[:page]).per(10)
    else
      @admin_serial_numbers = GameSerialNumber.select('id, serial_number, serial_type, status, created_at, updated_at'
        ).includes(:serial_type).where('game_id=? AND status=?', game_id, status
        ).page(params[:page]).per(10)
    end

    @serial_number_types = []
    (0..GameSerialNumber::STATUS-2).each do |i|
      temp_status = GameSerialNumber.select('status, count(*) as number, serial_type').includes(:serial_type).where('game_id=? AND status=?', game_id, i).group('serial_type').all
      temp_status.each do |item|
        number = @serial_number_types[item.serial_type.id] ? @serial_number_types[item.serial_type.id][:number] : []
        number[i] = item.number || 0
        @serial_number_types[item.serial_type.id] = {:type_name => item.serial_type.type_name, :type_desc => item.serial_type.type_desc, :number => number}
      end
    end
    puts @serial_number_types

    @serial_number_counts = GameSerialNumber.select('status, count(*) AS totalcount').where('game_id=?', game_id).group('status').all
    @serial_number_total_count = GameSerialNumber.where('game_id=?', game_id).count

    @serial_types = SerialType.select('serial_types.id, type_name').joins('LEFT JOIN game_serial_types AS gt ON gt.serial_type = serial_types.id').where('type_cat=? or game_id=?', SerialType::TYPE_BASIC, game_id).group('serial_types.id')

    @serial_type = SerialType.new
    @serial_type.type_cat = SerialType::TYPE_PRIVATE

    respond_to do |format|
      format.html # index.html.slim
      format.xml  { render :xml => @admin_serial_numbers }
    end
  end

  def game_serial_type
    game_id = params[:id]
    @game = Game.find(game_id)
    @public_serial_types = SerialType.where('type_cat =?', SerialType::TYPE_PUBLIC).all
    @private_serial_types = SerialType.where('type_cat =?', SerialType::TYPE_PRIVATE).all
    @basic_serial_types = SerialType.where('type_cat =?', SerialType::TYPE_BASIC).all
    game_serial_type_arr = GameSerialType.select('serial_type').where('game_id=?', game_id).all

    game_serial_type_arr.each do |serial|
      @game.serial_type_arr.push(serial.serial_type)
    end

    if request.put?
      begin
        ActiveRecord::Base.transaction do
          old_serial_type_arr = @game.serial_type_arr

          param_types = params[:game][:serial_type_arr]
          new_type_arr = Array.new
          param_types.each do |k, v|
            new_type_arr << k.to_i if v.to_i > 0
          end
          # exclude the basic type
          exclude_serial_types = @basic_serial_types.collect{|t| t.id.to_i}
          new_type_arr = new_type_arr - exclude_serial_types

          @game.serial_type_arr = new_type_arr
          deleted_serial_type_arr = old_serial_type_arr - @game.serial_type_arr

          deleted_serial_type_arr.each do |serial_type|
            deteled_serial_type = GameSerialType.where('game_id=? AND serial_type=?', @game.id, serial_type).first
            deteled_serial_type.destroy if deteled_serial_type
          end

          new_serial_type_arr = @game.serial_type_arr - old_serial_type_arr

          new_serial_type_arr.each do |serial_type|
            game_serial_type = GameSerialType.new(
                :game_id=>@game.id,
                :serial_type=>serial_type
            )

            game_serial_type.save!
          end
        end

        flash[:notice] = t('admin.msg.success')
        redirect_to game_serial_numbers_admin_game_path(@game)
      rescue
        #puts $!.to_s
        #puts $!.backtrace
      end
    end
  end

  def delete_selection
    @delete_form = Admin::GameSerialNumberDeleteForm.new(:game_id => params[:id])
    @game = Game.find(params[:id])

    respond_to do |format|
      format.html
    end
  end

  def import_serials
    err =nil
    game_id = params[:id].to_i
    serial_type = params[:serial_type].to_i
    serial_file = params[:serial_file].tempfile
    serial_status = params[:serial_status].to_i
    batch_number = params[:batch_number].to_i

    unless serial_file
      err = I18n.t("ERRORS.ERROR_HAVE_NOT_CHOOSE_A_SERIAL_FILE")
    end

    if serial_status < 0 || serial_status >= GameSerialNumber::STATUS
      err = I18n.t("ERRORS.ERROR_INVALID_SERIAL_STATUS")
    end

    serial_numbers = []
    File.open(serial_file, 'r').each_line do |line|
      serial_numbers << line
    end
    #ret = GameSerialNumber.import(serial_numbers, game_id, serial_type, serial_status, batch_number)

    #respond_to do |format|
    #end

    sql_str = ""
    connection = ActiveRecord::Base.connection
    serial_numbers = []
    File.open(serial_file, 'r').each_line do |line|
      serial_numbers << line
    end
    begin
      ActiveRecord::Base.transaction do
        serial_numbers.each_with_index do |serial_number, index|
          serial_number = serial_number.gsub(/\s+/, "")
          sql_str << "(NULL,#{game_id},#{serial_type},#{batch_number},'#{serial_number}',#{serial_status},NOW(),NOW())," unless serial_number == ""
          if sql_str != "" && ((index+1) % 50 == 0 || (index+1) == serial_numbers.count)
            sql_str = "INSERT INTO game_serial_numbers VALUES "  + sql_str[0..-2]
            connection.execute(sql_str)
            sql_str = ""
          end
        end
      end
    rescue
      puts $!.inspect
      puts $!.backtrace
      err = $!.inspect
    end

    if err == nil
      flash[:notice] = t('admin.msg.success')
      data = {}
    else
      flash[:error] = t('admin.msg.failed')
    end

    redirect_to game_serial_numbers_admin_game_path(game_id)
  end

  def manage_achievement
    game_id = params[:id]

    begin
      ActiveRecord::Base.transaction do
        @achievements = GameAchievement.find(
            :all,
            :select =>"game_id,achievement_name,title,description,icon,icon_locked",
            :conditions => ["game_id=?", game_id]
        )
      end
    rescue
      puts $!.inspect
      puts $!.backtrace
    end

    respond_to do |format|
      format.html # show.html.slim
      format.xml  { render :xml => @achievements }
    end
  end



  # => 设置外部关联
  def external_info
    ext_server_name = params[:admin_game_ext_id][:ext_platform]
    game_id = params[:admin_game_ext_id][:game_id]

    @game = Game.find(
        :first,
        :select => "id, alias_name, title",
        :conditions => ["id = ?", game_id]
    )

    @exit_ext = Admin::GameExtId.find(
        :first,
        :conditions => ["game_id = ? AND ext_platform = ?", game_id, ext_server_name]
    )

    unless @exit_ext
      @exit_ext = Admin::GameExtId.new(
          :game_id => game_id,
          :ext_platform => ext_server_name
      )
    end

    if !request.get?
      ext_id = params[:admin_game_ext_id][:ext_id]

      begin
        if ext_id && ext_id != ""
          @exit_ext.update_attributes(params[:admin_game_ext_id])
        else
          @exit_ext.destroy if @exit_ext
        end

        redirect_to( {:action =>"show", :id => game_id, :notice => '操作成功'})
      rescue
        puts $!.inspect
        puts $!.backtrace
      end
    end
  end

  def modify_home_page
    begin
      @game_id = params[:game_id].to_i

      template_dir = "#{Rails.root}/app/views/game_home_page"
      @templates = Array.new
      Dir.foreach(template_dir) do |template|
        @templates << template if template != "." && template != ".." && File.directory?(template_dir + "/" + template)
      end

      publisher_dir = "#{Rails.root}/public/images/publisher_logos"
      @publishers = Array.new
      Dir.foreach(publisher_dir) do |publisher|
        unless File.directory?(publisher_dir + "/" + publisher)
          @publishers << {:name => File.basename(publisher, File.extname(publisher)),
                          :url => "/images/publisher_logos/#{File.basename(publisher)}"}
        end
      end

      developer_dir = "#{Rails.root}/public/images/developer_logos"
      @developers = Array.new
      Dir.foreach(developer_dir) do |developer|
        unless File.directory?(developer_dir + "/" + developer)
          @developers << {:name => File.basename(developer, File.extname(developer)),
                          :url => "/images/developer_logos/#{File.basename(developer)}"}
        end
      end

      @game_home_page = GameHomePage.first(:conditions => ["game_id=?", @game_id])

      unless @game_home_page
        @game_home_page = GameHomePage.new
        @game_home_page.game_id = @game_id
        @game_home_page.logo = ""
        @game_home_page.image = ""
        @game_home_page.background_img = ""
        @game_home_page.brief = ""
        @game_home_page.publisher_logo = ""
        @game_home_page.developer_logo = ""
        @game_home_page.forum_addr = ""
        @game_home_page.title = ""
        @game_home_page.requirement = ""
        @game_home_page.template_name = "default"
      end

      if request.post?
        t = Time.now
        @game_home_page.template_name = params[:game_home_page][:template_name]
        #@game_home_page.logo = params[:game_home_page][:logo]
        #@game_home_page.image = params[:game_home_page][:image]
        #@game_home_page.background_img = params[:game_home_page][:background_img]
        @game_home_page.publisher_logo = params[:game_home_page][:publisher_logo]
        @game_home_page.developer_logo = params[:game_home_page][:developer_logo]
        @game_home_page.brief = params[:game_home_page][:brief]
        @game_home_page.forum_addr = params[:game_home_page][:forum_addr]
        @game_home_page.title = params[:game_home_page][:title]
        @game_home_page.requirement = params[:game_home_page][:requirement]
        @game_home_page.updated_at = t
        @game_home_page.created_at = t unless @game_home_page.id

        # save images
        if params[:game_home_page][:logo]
          ret = save_template_image(params[:game_home_page][:logo], "template", "logo", @game_id)
          @game_home_page.logo = ret[:url] if ret
        end

        if params[:game_home_page][:image]
          ret = save_template_image(params[:game_home_page][:image], "template", "image", @game_id)
          @game_home_page.image = ret[:url] if ret
        end

        if params[:game_home_page][:background_img]
          ret = save_template_image(params[:game_home_page][:background_img], "template", "bg", @game_id)
          @game_home_page.background_img = ret[:url] if ret
        end

        if params[:game_home_page][:download_background]
          ret = save_template_image(params[:game_home_page][:download_background], "template", "dlbg", @game_id)
          @game_home_page.download_background = ret[:url] if ret
        end

        @game_home_page.save!

        redirect_to "/g/#{@game_home_page.title}"
      end
    rescue
      puts $!.inspect
      puts $!.backtrace
      raise
    end
  end

  def modify_home_page_news
    begin
      @game_id = params[:game_id].to_i

      @game_home_page = GameHomePage.find(:first, :conditions => ["game_id=:game_id", {:game_id => @game_id}])
      unless @game_home_page
        render :text => "no home page"
        return
      end

      @news = GameHomeNews.paginate(:conditions => ["game_id=:game_id", {:game_id => @game_id}], :order => "created_at DESC", :per_page => 10, :page => params[:page])
    end
  end

  def modify_home_page_picture
    begin
      @game_id = params[:game_id].to_i
      @type = params[:type].to_i

      @game_home_page = GameHomePage.find(:first, :conditions => ["game_id=:game_id", {:game_id => @game_id}])
      unless @game_home_page
        render :text => "no home page"
        return
      end

      @pictures = GameHomePicture.find(:all, :order => "privilege", :conditions => ["game_id=:game_id AND picture_type=:type", {:game_id => @game_id, :type => @type}])
    end
  end

  def modify_home_page_video
    begin
      @game_id = params[:game_id].to_i

      @game_home_page = GameHomePage.find(:first, :conditions => ["game_id=:game_id", {:game_id => @game_id}])
      unless @game_home_page
        render :text => "no home page"
        return
      end

      @videos = GameHomeVideo.find(:all, :order => "privilege", :conditions => ["game_id=:game_id", {:game_id => @game_id}])
    end
  end

  def modify_home_page_download
    begin
      @game_id = params[:game_id].to_i
      @type = params[:type].to_i

      @game_home_page = GameHomePage.find(:first, :conditions => ["game_id=:game_id", {:game_id => @game_id}])
      unless @game_home_page
        render :text => "no home page"
        return
      end

      logo_dir = "#{Rails.root}/public/images/download_site_logos"
      @logos = Array.new
      Dir.foreach(logo_dir) do |logo|
        unless File.directory?(logo_dir + "/" + logo)
          @logos << {:name => File.basename(logo, File.extname(logo)),
                     :url => "/images/download_site_logos/#{File.basename(logo)}"}
        end
      end

      @downloads = GameHomeDownload.find(:all, :conditions => ["game_id=:game_id AND download_type=:type", {:game_id => @game_id, :type => @type}])
    end
  end

  def update_home_picture
    begin
      if request.post?
        game_id = params[:game_id].to_i
        picture_id = params[:picture_id].to_i
        type = params[:type]

        @game_home_picture = GameHomePicture.find(:first, :conditions => ["id=:picture_id AND game_id=:game_id", {:game_id => game_id, :picture_id => picture_id}])
        raise "no home picture" unless @game_home_picture

        if type != "privilege"
          if @game_home_picture.picture_type.to_i != params[:game_home_picture][:picture_type].to_i
            @game_home_picture.picture_type = params[:game_home_picture][:picture_type]
            max_privilege = GameHomePicture.find(:first, :select => "MAX(privilege) AS max_privilege", :conditions => ["game_id=:game_id AND picture_type=:type", {:game_id => game_id, :type => params[:game_home_picture][:picture_type]}]).max_privilege.to_i
            max_privilege = 0 unless max_privilege
            @game_home_picture.privilege = max_privilege + 1
          end
          @game_home_picture.picture_title = params[:game_home_picture][:picture_title]

          # save the picture
          if params[:game_home_picture][:picture]
            ret = save_template_image(params[:game_home_picture][:picture], "picture", "screenshot", game_id)
            raise I18n.t("page.admin.template.error.upload_failed") unless ret
            @game_home_picture.picture_url = ret[:url]
          end
          @game_home_picture.save!
        else
          position = params[:position].to_i
          if position > @game_home_picture.privilege.to_i
            ActiveRecord::Base.transaction do
              connection = ActiveRecord::Base.connection
              sql_str = "UPDATE game_home_pictures SET privilege=privilege-1 WHERE game_id=#{game_id} AND privilege>#{@game_home_picture.privilege} AND privilege<=#{position}"
              connection.execute(sql_str)
              @game_home_picture.privilege = position
              @game_home_picture.save!
            end
          elsif position < @game_home_picture.privilege.to_i
            ActiveRecord::Base.transaction do
              connection = ActiveRecord::Base.connection
              sql_str = "UPDATE game_home_pictures SET privilege=privilege+1 WHERE game_id=#{game_id} AND privilege<#{@game_home_picture.privilege} AND privilege>=#{position}"
              connection.execute(sql_str)
              @game_home_picture.privilege = position
              @game_home_picture.save!
            end
          end
        end

        if request.xhr?
          render :json => {:result => RET_SUCCESS}
        else
          redirect_to :action => :modify_home_page_picture, :game_id => game_id, :type => @game_home_picture.picture_type
        end
      end
    rescue => e
      if request.xhr?
        render :json => {:result => RET_FAILED}
      else
        render :text => e.message
      end
    end
  end

  def create_home_picture
    begin
      if request.post?
        game_id = params[:game_id].to_i
        @game_home_page = GameHomePage.find(:first, :conditions => ["game_id=:game_id", {:game_id => game_id}])
        raise "no home page" unless @game_home_page

        max_privilege = GameHomePicture.find(:first, :select => "MAX(privilege) AS max_privilege", :conditions => ["game_id=:game_id AND picture_type=:type", {:game_id => game_id, :type => params[:game_home_picture][:picture_type]}]).max_privilege.to_i
        max_privilege = 0 unless max_privilege
        @game_home_picture = GameHomePicture.new
        @game_home_picture.game_id = game_id
        @game_home_picture.picture_type = params[:game_home_picture][:picture_type]
        @game_home_picture.picture_title = params[:game_home_picture][:picture_title]
        @game_home_picture.privilege = max_privilege + 1

        # save the picture
        if params[:game_home_picture][:picture]
          ret = save_template_image(params[:game_home_picture][:picture], "picture", "screenshot", game_id)
          raise I18n.t("page.admin.template.error.upload_failed") unless ret
          @game_home_picture.picture_url = ret[:url]
        end

        @game_home_picture.save!
        redirect_to :action => :modify_home_page_picture, :game_id => game_id, :type => @game_home_picture.picture_type
      end
    rescue => e
      render :text => e.message
    end
  end

  def delete_home_picture
    begin
      if request.post?
        game_id = params[:game_id].to_i
        picture_id = params[:picture_id].to_i

        ActiveRecord::Base.transaction do
          @game_home_picture = GameHomePicture.find(:first, :conditions => ["id=:picture_id AND game_id=:game_id", {:game_id => game_id, :picture_id => picture_id}], :lock => "LOCK IN SHARE MODE")
          raise "no home news" unless @game_home_picture

          # update the privilege
          connection = ActiveRecord::Base.connection
          sql_str = "UPDATE game_home_pictures SET privilege=privilege-1 WHERE game_id=#{game_id} AND privilege>#{@game_home_picture.privilege} "
          connection.execute(sql_str)
          unless @game_home_picture.destroy
            raise
          end
        end
        render :json => {:result => RET_SUCCESS}
      end
    rescue
      render :json => {:result => RET_FAILED}
    end
  end

  def create_home_news
    begin
      if request.post?
        game_id = params[:game_id].to_i
        @game_home_page = GameHomePage.find(:first, :conditions => ["game_id=:game_id", {:game_id => game_id}])
        raise "no home page" unless @game_home_page

        @game_home_news = GameHomeNews.new
        @game_home_news.game_id = game_id
        @game_home_news.news_type = params[:game_home_news][:news_type]
        @game_home_news.news_title = params[:game_home_news][:news_title]
        @game_home_news.news_content = params[:game_home_news][:news_content]

        @game_home_news.save!
        redirect_to :action => :modify_home_page_news, :game_id => game_id
      end
    end
  end

  def update_home_news
    begin
      if request.post?
        game_id = params[:game_id].to_i
        news_id = params[:news_id].to_i

        @game_home_news = GameHomeNews.find(:first, :conditions => ["id=:news_id AND game_id=:game_id", {:game_id => game_id, :news_id => news_id}])
        raise "no home news" unless @game_home_news
        @game_home_news.news_type = params[:game_home_news][:news_type]
        @game_home_news.news_title = params[:game_home_news][:news_title]
        @game_home_news.news_content = params[:game_home_news][:news_content]

        @game_home_news.save!
        redirect_to :action => :modify_home_page_news, :game_id => game_id
      end
    end
  end

  def delete_home_news
    begin
      if request.post?
        game_id = params[:game_id].to_i
        news_id = params[:news_id].to_i

        @game_home_news = GameHomeNews.find(:first, :conditions => ["id=:news_id AND game_id=:game_id", {:game_id => game_id, :news_id => news_id}])
        raise "no home news" unless @game_home_news

        unless @game_home_news.destroy
          raise
        end
        render :json => {:result => RET_SUCCESS}
      end
    rescue
      render :json => {:result => RET_FAILED}
    end
  end

  def create_home_download
    begin
      if request.post?
        game_id = params[:game_id].to_i
        @game_home_page = GameHomePage.find(:first, :conditions => ["game_id=:game_id", {:game_id => game_id}])
        raise "no home page" unless @game_home_page

        @game_home_download = GameHomeDownload.new
        @game_home_download.game_id = game_id
        @game_home_download.download_type = params[:game_home_download][:download_type]
        @game_home_download.title = params[:game_home_download][:title]
        @game_home_download.url = params[:game_home_download][:url]
        @game_home_download.download_site_logo = params[:game_home_download][:download_site_logo]

        @game_home_download.save!
        redirect_to :action => :modify_home_page_download, :game_id => game_id, :type => @game_home_download.download_type
      end
    rescue
      render :text => "failed"
    end
  end

  def update_home_download
    begin
      if request.post?
        game_id = params[:game_id].to_i
        download_id = params[:download_id].to_i

        @game_home_download = GameHomeDownload.find(:first, :conditions => ["id=:download_id AND game_id=:game_id", {:game_id => game_id, :download_id => download_id}])
        raise "no home download" unless @game_home_download
        @game_home_download.download_type = params[:game_home_download][:download_type]
        @game_home_download.title = params[:game_home_download][:title]
        @game_home_download.url = params[:game_home_download][:url]
        @game_home_download.download_site_logo = params[:game_home_download][:download_site_logo]

        @game_home_download.save!
        redirect_to :action => :modify_home_page_download, :game_id => game_id, :type => @game_home_download.download_type
      end
    rescue
      render :text => "failed"
    end
  end

  def delete_home_download
    begin
      if request.post?
        game_id = params[:game_id].to_i
        download_id = params[:download_id].to_i

        @game_home_download = GameHomeDownload.find(:first, :conditions => ["id=:download_id AND game_id=:game_id", {:game_id => game_id, :download_id => download_id}])
        raise "no home download" unless @game_home_download

        unless @game_home_download.destroy
          raise
        end
        render :json => {:result => RET_SUCCESS}
      end
    rescue
      render :json => {:result => RET_FAILED}
    end
  end

  def update_home_video
    begin
      if request.post?
        game_id = params[:game_id].to_i
        video_id = params[:video_id].to_i
        type = params[:type]

        @game_home_video = GameHomeVideo.find(:first, :conditions => ["id=:video_id AND game_id=:game_id", {:game_id => game_id, :video_id => video_id}])
        raise "no home video" unless @game_home_video

        if type != "privilege"
          @game_home_video.video_title = params[:game_home_video][:video_title]
          @game_home_video.video_url = params[:game_home_video][:video_url]

          # save the picture
          if params[:game_home_video][:screenshot_url]
            ret = save_template_image(params[:game_home_video][:screenshot_url], "picture", "screenshot", game_id)
            raise I18n.t("page.admin.template.error.upload_failed") unless ret
            @game_home_video.screenshot_url = ret[:url]
          end

          @game_home_video.save!
        else
          position = params[:position].to_i
          if position > @game_home_video.privilege.to_i
            ActiveRecord::Base.transaction do
              connection = ActiveRecord::Base.connection
              sql_str = "UPDATE game_home_videos SET privilege=privilege-1 WHERE game_id=#{game_id} AND privilege>#{@game_home_video.privilege} AND privilege<=#{position}"
              connection.execute(sql_str)
              @game_home_video.privilege = position
              @game_home_video.save!
            end
          elsif position < @game_home_video.privilege.to_i
            ActiveRecord::Base.transaction do
              connection = ActiveRecord::Base.connection
              sql_str = "UPDATE game_home_videos SET privilege=privilege+1 WHERE game_id=#{game_id} AND privilege<#{@game_home_video.privilege} AND privilege>=#{position}"
              connection.execute(sql_str)
              @game_home_video.privilege = position
              @game_home_video.save!
            end
          end
        end

        if request.xhr?
          render :json => {:result => RET_SUCCESS}
        else
          redirect_to :action => :modify_home_page_video, :game_id => game_id
        end
      end
    rescue => e
      if request.xhr?
        render :json => {:result => RET_FAILED}
      else
        render :text => e.message
      end
    end
  end

  def create_home_video
    begin
      if request.post?
        game_id = params[:game_id].to_i
        @game_home_page = GameHomePage.find(:first, :conditions => ["game_id=:game_id", {:game_id => game_id}])
        raise "no home page" unless @game_home_page

        max_privilege = GameHomeVideo.find(:first, :select => "MAX(privilege) AS max_privilege", :conditions => ["game_id=:game_id", {:game_id => game_id}]).max_privilege.to_i
        max_privilege = 0 unless max_privilege
        @game_home_video = GameHomeVideo.new
        @game_home_video.game_id = game_id
        @game_home_video.video_title = params[:game_home_video][:video_title]
        @game_home_video.video_url = params[:game_home_video][:video_url]
        @game_home_video.privilege = max_privilege + 1

        # save the picture
        if params[:game_home_video][:screenshot_url]
          ret = save_template_image(params[:game_home_video][:screenshot_url], "picture", "screenshot", game_id)
          raise I18n.t("page.admin.template.error.upload_failed") unless ret
          @game_home_video.screenshot_url = ret[:url]
        end

        @game_home_video.save!
        redirect_to :action => :modify_home_page_video, :game_id => game_id
      end
    rescue => e
      render :text => e.message
    end
  end

  def delete_home_video
    begin
      if request.post?
        game_id = params[:game_id].to_i
        video_id = params[:video_id].to_i

        ActiveRecord::Base.transaction do
          @game_home_video = GameHomeVideo.find(:first, :conditions => ["id=:video_id AND game_id=:game_id", {:game_id => game_id, :video_id => video_id}], :lock => "LOCK IN SHARE MODE")
          raise "no home video" unless @game_home_video

          # update the privilege
          connection = ActiveRecord::Base.connection
          sql_str = "UPDATE game_home_videos SET privilege=privilege-1 WHERE game_id=#{game_id} AND privilege>#{@game_home_video.privilege} "
          connection.execute(sql_str)
          unless @game_home_video.destroy
            raise
          end
        end
        render :json => {:result => RET_SUCCESS}
      end
    rescue
      render :json => {:result => RET_FAILED}
    end
  end

  private

  def validate_idt
    err = AdminController.validate_identity(session[:admin_identity], Role::ID_EDIT_GAMES)
    unless  err == nil
      render(:text => err)
    end
  end

  def save_template_image(data, type, subtype, game_id)
    begin
      ext = nil
      data = data.read
      case data[0..9]
        when Regex.new('^GIF8'.force_encoding("US_ASCII"))
          ext = 'gif'
        when Regex.new('^\x89PNG'.force_encoding("US_ASCII"))
          ext = 'png'
        when Regex.new('^\xff\xd8\xff\xe0\x00\x10JFIF'.force_encoding("US_ASCII"))
          ext = 'jpg'
        when Regex.new('^\xff\xd8\xff\xe1(.*){2}Exif'.force_encoding("US_ASCII"))
          ext = 'jpg'
        else
          return nil
      end

      return nil unless ext

      file_dir = "#{Rails.root}/public/images/game_home_page"
      Dir.mkdir(file_dir) unless File.exist?(file_dir)
      return nil unless File.directory?(file_dir)

      if type == "template"
        f = File.open(File.join(file_dir, "#{game_id}_#{subtype}.#{ext}"), "wb")
        f.write(data)
        f.close
        {:path => File.join(file_dir, "#{game_id}_#{type}_#{ext}"), :url => "/images/game_home_page/#{game_id}_#{subtype}.#{ext}"}
      elsif type == "picture"
        uuid = UUIDTools::UUID.timestamp_create.to_s.delete('-')
        file_path = File.join(file_dir, "#{game_id}_#{uuid}.#{ext}")
        f = File.open(file_path, "wb")
        f.write(data)
        f.close

        #resize
        dest_file = File.join(file_dir, "#{game_id}_#{uuid}_s.#{ext}")
        ret = resize_image?(file_path, dest_file, 300)
        raise "resize failed" unless ret
        {:path => file_path, :thumbnail => dest_file, :url => "/images/game_home_page/#{game_id}_#{uuid}.#{ext}", :thumbnail_url => "/images/game_home_page/#{game_id}_#{uuid}_s.#{ext}"}
      else
        nil
      end
    rescue
      nil
    end
  end

end

