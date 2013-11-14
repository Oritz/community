# -*- encoding : utf-8 -*-
require 'net/http'
require 'net/https'
require 'rexml/document'
require 'cache/sys_params_cache'
require "cache/serial_types_cache"

#require 'openssl'

class Api::GameController < ApplicationController
  before_filter :sonkwo_authenticate_account

  # 获得玩家所有个人游戏信息，仅在客户端
  def list_my_games
    begin
      account_id = current_account.id

      ret = nil
      online_user_games =nil

      # 系统内购买的游戏
      online_user_games = UserGame.find(
        :all,
        :select =>"user_games.game_id AS gameId, games.name AS gameName, games.english_name AS gameEngName,
           games.cap_image AS gameThumbnail, games.icon_image AS gameIcon, games.product_image AS productImage, games.rating AS gameRating,
           dlcs.parent_id AS gameParent, games.install_type AS installType, games.manual AS manualUri,
           games.forum_addr AS forumAddr, MAX(game_files.patch_ver) AS patchVer, MAX(game_files.ini_ver) AS iniVer, MAX(game_files.shell_ver) AS shellVer",
        :joins =>"INNER JOIN games ON games.id=user_games.game_id
                  LEFT JOIN game_files ON game_files.game_id=games.id
                  LEFT JOIN game_dlcs AS dlcs ON dlcs.id=user_games.game_id",
        :conditions => ["user_games.account_id=?", account_id],
        :group => "user_games.game_id",
        :order=>"games.id ASC"
      )

      # 非系统内购买的游戏
      offline_games = UserGameSerial.find(
        :all,
          :select =>"user_game_serials.game_id AS gameId, games.name AS gameName, games.english_name AS gameEngName,
           games.cap_image AS gameThumbnail, games.icon_image AS gameIcon, games.product_image AS productImage, games.rating AS gameRating,
           dlcs.parent_id AS gameParent, games.install_type AS installType, games.manual AS manualUri,
           games.forum_addr AS forumAddr, MAX(game_files.patch_ver) AS patchVer, MAX(game_files.ini_ver) AS iniVer, MAX(game_files.shell_ver) AS shellVer",
          :joins =>"INNER JOIN games ON games.id=user_game_serials.game_id
                  LEFT JOIN game_files ON game_files.game_id=games.id
                  LEFT JOIN game_dlcs AS dlcs ON dlcs.id = user_game_serials.game_id",
        :conditions => ["user_game_serials.account_id=? AND game_files.status=? AND serial_type IN (?)", account_id, GameFile::STATUS_VALIDATED, [SerialTypesCache.get_id_by_type_name(GameSerialType::TYPE_NAME_OFFLINE), SerialTypesCache.get_id_by_type_name(GameSerialType::TYPE_NAME_RETAIL), SerialTypesCache.get_id_by_type_name(GameSerialType::TYPE_NAME_TRIAL)]],
        :group => "user_game_serials.game_id",
        :order=>"games.id ASC"
      )

      user_games = online_user_games + offline_games

      all_patch_vers = {}  # 每个游戏一个数组

      
      user_games.collect do |game|
        game.forumAddr ||= 'http://' + SysParamsCache.get('FORUM_HOME_PAGE')  # add by shx, replace the default value

        # 获取patch list
        patches = GameFile.find(
          :all,
          :select =>"DISTINCT(patch_ver)",
          :conditions=>["game_id=? AND status=?", game.gameId, GameFile::STATUS_VALIDATED],
          :order=>"patch_ver ASC"
        )
        
        all_patch_vers[game.gameId] = patches
      end
      
      ret = { :status => "success", :data => {:games=>user_games, :all_patch_vers=>all_patch_vers} }
    rescue
      ret = { :status => "error", :message => I18n.t("ERRORS.ERROR_UNKNOW") }
    end

    render :json=>ret
  end


  # 获取玩家游戏id列表
  def list_my_game_ids
    begin
      account_id = current_account.id

      ret = nil
      online_user_games =nil


      # 系统内购买的游戏
      online_user_games = UserGame.find(
        :all,
        :select =>"DISTINCT(game_id) AS gameId",
        :conditions => ["account_id=?", account_id],
        :order=>"game_id ASC"
      )

      # 非系统内购买的游戏
      offline_games = UserGameSerial.find(
        :all,
        :select =>"DISTINCT(game_id) AS gameId",
        :conditions => ["account_id=? AND serial_type IN (?)", account_id, [SerialTypesCache.get_id_by_type_name(GameSerialType::TYPE_NAME_OFFLINE), SerialTypesCache.get_id_by_type_name(GameSerialType::TYPE_NAME_RETAIL), SerialTypesCache.get_id_by_type_name(GameSerialType::TYPE_NAME_TRIAL)]],
        :order=>"game_id ASC"
      )

      user_games = online_user_games + offline_games

      ret = { :status => "success", :data => {:games => user_games} }
    rescue
      ret = { :status => "error", :message => I18n.t("ERRORS.ERROR_UNKNOW") }
    end
    
    render :json=>ret
  end


  # 根据游戏ID或游戏名获取单个游戏信息
  def get_game_info
    game_id = params[:game_id]
    game_name = params[:game_name]
    
    if game_id
      conditions = ["games.id=?", game_id]
    else
      conditions = ["games.english_name=?", game_name]
    end
    
    begin
      game = Game.find(
        :first,
        :select =>"games.id AS gameId, games.name AS gameName, games.english_name AS gameEngName,
           games.cap_image AS gameThumbnail, games.icon_image AS gameIcon, games.rating AS gameRating,
           dlcs.parent_id AS gameParent, games.install_type AS installType, games.manual AS manualUri,
           games.forum_addr AS forumAddr, MAX(game_files.patch_ver) AS patchVer, MAX(game_files.ini_ver) AS iniVer, MAX(game_files.shell_ver) AS shellVer",
        :joins => "LEFT JOIN game_files ON game_files.game_id=games.id
                   LEFT JOIN game_dlcs AS dlcs ON dlcs.id=games.id",
        :conditions => conditions,
        :group => "games.id",
        :order=>"games.id ASC"
      )
      
      if game
        game.forumAddr ||= 'http://' + SysParamsCache.get('FORUM_HOME_PAGE')

        # 获取patch list
        patch_vers = GameFile.find(
          :all,
          :select =>"DISTINCT(patch_ver)",
          :conditions=>["game_id=? AND status=?", game.gameId, GameFile::STATUS_VALIDATED],
          :order=>"patch_ver ASC"
        )

        ret = { :status => "success", :data => {:game=>game, :patch_vers=>patch_vers} }
      else
        ret = { :status => "fail", :data => { :message => I18n.t("ERRORS.ERR_GAME_NOT_EXIST") } }
      end
    rescue
      ret = { :status => "error", :message => I18n.t("ERRORS.ERROR_UNKNOW") }
    end
    
    render :json=>ret
  end
  
  
  def get_game_dlcs
    begin
      game_id = params[:game_id].to_i
      # game_id       //dlc的id
      # game_name     //名称
      # english_name  //英文名
      # release_date  //发布时间
      # description   //描述
      # sell_price    //销售价格
      # link          //下载链接
      # icon_image    //图标
      data = Game.find(
        :all,
        :select =>"games.id AS gameId, games.name AS gameName, games.english_name AS gameEngName, games.product_image AS iconImage, 
           games.release_date AS releaseDate, games.description AS description, games.sell_price AS sellPrice, games.link AS link",
        :joins => "INNER JOIN game_dlcs ON game_dlcs.id=games.id",
        :conditions => ["game_dlcs.parent_id=?", game_id],
        :order=>"games.id ASC"
      )

      dlcs = Array.new
      data.each do |item|
        dlcs << {
          :gameId => item.gameId,
          :gameName => item.gameName,
          :gameEngName => item.gameEngName,
          :iconImage => item.iconImage.gsub("public://", "http://#{SysParamsCache.get('MALL_HOME_PAGE')}/sites/default/files/"),
          :releaseDate => item.releaseDate,
          :description => item.description,
          :sellPrice => item.sellPrice,
          :link => "http://#{SysParamsCache.get('MALL_HOME_PAGE')}/node/#{item.gameId}"
        }
      end

      ret = { :status => "success", :data => {:base_game_id=>game_id, :dlcs=>dlcs } }
    rescue
      ret = { :status => "error", :message => I18n.t("ERRORS.ERROR_UNKNOW") }
    end
    
    render :json=>ret
  end


  
  # # 获取game shell版本号和digest——已经放到GameController::list_my_games/get_game_info获得
  # def get_game_shell_ver
    # ret = nil
    # err = nil

    # game_id = params[:game_id]

    # begin
      # game_file_info = GameFile.find(
        # :first,
        # :select=>"id, shell_ver",
        # :conditions=>["game_id=? AND status=?", game_id, GameFile::STATUS_VALIDATED],
        # :order=>"created_at DESC"
      # )

      # if game_file_info
        # ret = { :result=>RET_SUCCESS, :ver=>game_file_info.shell_ver}
      # else
        # ret = { :result=>RET_FAILED, :err=>I18n.t("ERRORS.ERR_GAME_SHELL_NOT_EXIST") }
      # end
    # rescue
      # puts $!.inspect
      # puts $!.backtrace
      # ret = { :result=>RET_FAILED, :error=>$!.to_s }
    # end

    # render :json=>ret
  # end



  # 获取游戏game_shell
  # 返回值：
  #  成功：shell_length(int32) + game_shell
  #  失败：-1(int32) + 错误说明
  def request_game_shell
    ret = nil
    err = nil

    game_id = params[:game_id]

    begin
      ActiveRecord::Base.transaction do
        game_file_info = GameFile.find(
          :first,
          :select=>"id, game_shell",
          :conditions=>["game_id=? AND status=?", game_id, GameFile::STATUS_VALIDATED],
          :order=>"created_at DESC"
        )

        if game_file_info == nil
          err = I18n.t("ERRORS.ERR_GAME_SHELL_NOT_EXIST")
        else
          shell_bytes_array = game_file_info.game_shell.bytes.to_a
          shell_length = shell_bytes_array.size
          ret = [shell_length & 0xFF, (shell_length >> 8) & 0xFF, (shell_length >> 16) & 0xFF, (shell_length >> 24) & 0xFF] + shell_bytes_array
        end
      end
    rescue
      puts $!.inspect
      puts $!.backtrace
      err = $!.to_s
    end

    if err
      #puts "err: #{err}"
      ret = [0xFF, 0xFF, 0xFF, 0xFF] + err.bytes.to_a + [0]
      # ret = [0xFFFF].pack("s").unpack("C*") + err.bytes.to_a
    end

    send_data ret.pack("C*"), :filename => 'game_shell.dat', :disposition => 'inline'
  end
  
  
  
  # # 获取game ini版本号和digest——已经放到GameController::list_my_games/get_game_info获得
  # def get_game_ini_ver
    # game_id = params[:game_id]

    # ret = nil
    # err = nil

    # begin
      # game_file_info = GameFile.find(
        # :first,
        # :select=>"id, ini_ver",
        # :conditions=>["game_id=? AND status=?", game_id, GameFile::STATUS_VALIDATED],
        # :order=>"created_at DESC"
      # )


      # if game_file_info
        # ret = { :result=>RET_SUCCESS, :ver=>game_file_info.ini_ver}
      # else
        # ret = { :result=>RET_FAILED, :err=>I18n.t("ERRORS.ERR_GAME_INI_NOT_EXIST") }
      # end
    # rescue
      # puts $!.inspect
      # puts $!.backtrace
      # ret = { :result=>RET_FAILED, :error=>$!.to_s }
    # end

    # render :json=>ret
  # end



  # 获取游戏game_ini
  # 返回值：
  #  成功：ini_length(int32) + game_ini
  #  失败：-1(int32) + 错误说明
  def request_game_ini
    game_id = params[:game_id]
    #ver = params[:ver]

    ret = nil
    err = nil

    begin
      game_file_info = GameFile.find(
        :first,
        :select=>"id, game_ini",
        :conditions=>["game_id=? AND status=?", game_id, GameFile::STATUS_VALIDATED],
        :order=>"created_at DESC"
      )

      if game_file_info == nil
        err = I18n.t("ERRORS.ERR_GAME_INI_NOT_EXIST")
      else

        ini_bytes_array = game_file_info.game_ini.bytes.to_a
        ini_length = ini_bytes_array.size
        ret = [ini_length & 0xFF, (ini_length >> 8) & 0xFF, (ini_length >> 16) & 0xFF, (ini_length >> 24) & 0xFF] + ini_bytes_array
      end
    rescue
      puts $!.inspect
      puts $!.backtrace
      err = $!.to_s
    end

    if err
      puts "err: #{err}"
      ret = [0xFF, 0xFF, 0xFF, 0xFF] + err.bytes.to_a + [0]
      # ret = [0xFFFF].pack("s").unpack("C*") + err.bytes.to_a
    end

    send_data ret.pack("C*"), :filename => 'game_ini.dat', :disposition => 'inline'
  end

  
  # # 获取某个版本之后所有版本号——已经放到GameController::list_my_games/get_game_info获得
  # def get_patch_list
    # game_id = params[:game_id]
    # since_ver = params[:since_ver]
  
    # begin
      # patch_vers = GameFile.find(
        # :all,
        # :select =>"DISTINCT(patch_ver)",
        # :conditions=>["game_id=? AND patch_ver>? AND status=?", game_id, since_ver, GameFile::STATUS_VALIDATED],
        # :order=>"patch_ver ASC"
      # )

      # ret = { :result=>RET_SUCCESS, :patch_vers=>patch_vers }
    # rescue
      # puts $!.inspect
      # puts $!.backtrace
      # ret = { :result=>RET_FAILED, :error=>$!.to_s }
    # end

    # render :json=>ret
  # end
  


  # 获取游戏种子
  def get_game_seed
    game_id = params[:game_id]
    patch_ver = params[:patch_ver]

    ret = nil
    user_games =nil


    begin
      game_file = GameFile.find(
        :first,
        :select =>"seed_content",
        :conditions=>["game_id=? AND patch_ver=? AND status=?", game_id, patch_ver, GameFile::STATUS_VALIDATED],
        :order=>"created_at DESC"
      )
  
      if game_file
        seed_content = game_file.seed_content.bytes.to_a
        length = seed_content.length
        ret = [length & 0xFF, (length >> 8) & 0xFF, (length >> 16) & 0xFF, length >> 24] + seed_content
      else
        ret = [0xFF, 0xFF, 0xFF, 0xFF] + I18n.t("ERRORS.ERROR_NO_GAME_SEED").bytes.to_a + [0]
      end
    rescue
      puts $!.inspect
      puts $!.backtrace
      ret = [0xFF, 0xFF, 0xFF, 0xFF] + $!.to_s.bytes.to_a + [0]
    end
    
    send_data ret.pack("C*"), :filename => "seed_#{game_id}_#{patch_ver}.dat", :disposition => 'inline'
  end


  # List achievement of a specific game
  def list_game_achievements
    # account_id = current_account.id
    achievements = nil
    game_id = params[:game_id]

    begin
      achievements = GameAchievement.find(
        :all,
        :select =>"game_id,achievement_name,title,description,icon,icon_locked",
        :conditions => ["game_id=?",game_id]
      )

      achievements.each do |achievement|
        achievement['title'] = CGI::unescape(achievement['title'])
        achievement['description'] = CGI::unescape(achievement['description'])
      end
      
      ext_platform = GameExtId.find(
        :first,
        :select=>"ext_platform",
        :conditions=>["game_id=?", game_id]
      )

      ret = {
        :status => "success",
        :data => {
          :achievements=>achievements,
          :ext_platform=>(ext_platform)? ext_platform.ext_platform : nil
        }
      }
    rescue
      ret = { :status => "error", :message => I18n.t("ERRORS.ERROR_UNKNOW") }
    end
    render :json=>ret
  end


  # List unlocked achievements of current account
  def list_my_achievements
    account_id = current_account.id
    achievements = nil
    game_id = params[:game_id]

    begin
      achievements = PlayerAchievement.find(
        :all,
        :select =>"game_id,achievement_name,achievement_value,UNIX_TIMESTAMP(player_achievements.created_at) AS unlocked_time",
        :joins => "INNER JOIN game_achievements ON game_achievement_id=game_achievements.id",
        :conditions => ["account_id=? AND game_id=?",account_id, game_id]
      )
      
      bind_info = UserExtId.find(
        :first,
        :select=>"ext_platform, ext_id",
        :conditions=>["account_id=?", account_id]
      )
  
      ret = {
        :status => "success",
        :data => {
          :achievements=>achievements,
          :bind_info=>bind_info
        }
      }
    rescue
      ret = { :status => "error", :message => I18n.t("ERRORS.ERROR_UNKNOW") }
    end
    
    render :json=>ret
  end


  #上传游戏成就
  #need re-write
=begin
  def post_achievements
    if request.post?
      count = 0
      begin
        ActiveRecord::Base.transaction do
          account_id = current_account.id
          game_id = params[:game_id]

          params.delete(:game_id)
          params.delete(:action)
          params.delete(:controller)
          params.delete(:authenticity_token)

          achv_name = ""
          achv_value = ""


          params.each_pair do |key, value|
            #next if key == "action"
            #next if key == "controller"

            achv_name = key
            achv_value = value

            if game_id != nil
              my_achievements = PlayerAchievement.new
              my_achievements.account_id = account_id
              my_achievements.game_id = game_id
              my_achievements.achievement_name = achv_name
              my_achievements.achievement_value = achv_value
              #my_achievements.created_at = create_at
              my_achievements.save!
              count = count + 1
              puts count
            end
          end
        end

        ret = { :result=>RET_SUCCESS, :save_count => count }
      rescue
        puts $!.inspect
        puts $!.backtrace
        #@errors = $!.to_s
        ret = { :result=>RET_FAILED, :error=>$!.to_s }
      end
      render :json=>ret
      #render:nothing=>true
    end
  end
=end

  # 获取游戏相关的序列码
  def get_serial_number
    game_id = params[:game_id]
    account_id = current_account.id

    user_game_serials =[]
    err = nil

    begin
      ActiveRecord::Base.transaction do
        serial_types_to_allocate = []

        # 检查用户是否已经订购过该游戏 —— 只有订购的情况，才需要在这里分配关联的序列号
        user_game = UserGame.find(
          :first,
          :select=>"game_id",
          :conditions => ["account_id=? AND game_id=?", account_id, game_id],
          :lock=>"LOCK IN SHARE MODE"
        )

        if user_game
          # 用户已订购该游戏
          err = allocate_missing_serial_types(account_id, game_id, GameSerialType::TYPE_NAME_ONLINE)
        else
          offline_product_key = UserGameSerial.find(
            :first,
            :select => "game_id, serial_number, type_name",
            :joins => "INNER JOIN serial_types ON serial_type=serial_types.id",
            :conditions => ["account_id=? AND game_id=? AND serial_type IN (?)", account_id, game_id, [SerialTypesCache.get_id_by_type_name(GameSerialType::TYPE_NAME_OFFLINE), SerialTypesCache.get_id_by_type_name(GameSerialType::TYPE_NAME_RETAIL)]],
            :lock => "LOCK IN SHARE MODE"
          )  # OFFLINE/RETAIL相对于TRIAL，优先显示

          if offline_product_key
            # 用户已经拥有离线的KEY，分配缺失的关联类型的KEY
            err = allocate_missing_serial_types(account_id, game_id, offline_product_key.type_name)
          else
            trial_product_key = UserGameSerial.find(
              :first,
              :select => "game_id, serial_number",
              :conditions => ["account_id=? AND game_id=? AND serial_type=?", account_id, game_id, SerialTypesCache.get_id_by_type_name(GameSerialType::TYPE_NAME_TRIAL)],
              :lock => "LOCK IN SHARE MODE"
            )
            
            if trial_product_key
              # 用户已经拥有试用KEY，分配缺失的关联类型的KEY
              err = allocate_missing_serial_types(account_id, game_id, GameSerialType::TYPE_NAME_TRIAL)
            end
          end
        end

        if err
           raise ActiveRecord::Rollback
        end

        # 查找所有类型的KEY并返回
        user_game_serials = UserGameSerial.find(
          :all,
          :select =>"type_desc AS serial_desc, serial_number",
          :conditions => ["account_id=? AND game_id=?", account_id, game_id],
          :joins=>"INNER JOIN serial_types ON serial_type=serial_types.id",
          :lock=>true
        )
      end
    rescue
      err = $!.to_s
    end

    if err == nil
      ret ={ :status => "success", :data => {:user_serial_numbers => user_game_serials} }
    else
      ret = { :status => "error", :message => I18n.t("ERRORS.ERROR_UNKNOW") }
    end

    render :json =>ret
  end

  
  # 客户端或者网页注册序列号
  def register_serial_number
    if request.post?
      serial_number = params[:serial_number]
      account_id = current_account.id
  
      register_game = nil
      err = nil
  
      begin
        ActiveRecord::Base.transaction do
          # 检查序列号是否有效
          input_serial_number = GameSerialNumber.find(
            :first,
            :conditions => ["serial_number=? AND (status=? OR status=? OR status=?)", serial_number, GameSerialNumber::STATUS_ALLOCATED, GameSerialNumber::STATUS_FRESH, GameSerialNumber::STATUS_USED],
            :lock => true
          )
         
          input_serial_type_name = nil

          if input_serial_number
            if input_serial_number.status == GameSerialNumber::STATUS_USED
              err = I18n.t("ERRORS.ERROR_SERIAL_NUMBER_USED")
              raise ActiveRecord::Rollback
            end
            # 查找可激活序列号类型，并获取类型名
            allowed_serial_types = SerialType.find(
              :all,
              :select => "id, type_name",
              :conditions => ["serial_types.type_name IN (?)", [GameSerialType::TYPE_NAME_OFFLINE, GameSerialType::TYPE_NAME_RETAIL, GameSerialType::TYPE_NAME_TRIAL]]
            )
              
            allowed_serial_types.each do |serial_type|
              if serial_type.id == input_serial_number.serial_type
                input_serial_type_name = serial_type.type_name
                break
              end
            end
          end

          if !input_serial_number || !input_serial_type_name
            err = I18n.t("ERRORS.ERROR_SERIAL_NUMBER_INVALID")
            raise ActiveRecord::Rollback
          end
            
          game_id = input_serial_number.game_id
          
          #
          # 检查是否已经拥有该游戏
         
          online_order = UserGame.find(
            :first,
            :select=>"game_id",
            :conditions =>["account_id=? AND game_id=?", account_id, game_id],
            :lock=>"LOCK IN SHARE MODE"
          )
          
          unless online_order
            offline_product_key = UserGameSerial.find(
              :first,
              :select=>"user_game_serials.id AS id",
              :conditions =>["account_id=? AND game_id=? AND serial_type IN (?)", account_id, game_id, [SerialTypesCache.get_id_by_type_name(GameSerialType::TYPE_NAME_OFFLINE), SerialTypesCache.get_id_by_type_name(GameSerialType::TYPE_NAME_RETAIL)]],
              :lock=>"LOCK IN SHARE MODE"
            )# 离线下载版或者第三方购买或者光盘零售版
              
            if !offline_product_key
              trial_product_key = UserGameSerial.find(
                :first,
                :select=>"user_game_serials.id AS id",
                :conditions =>["account_id=? AND game_id=? AND serial_type=?", account_id, game_id, SerialTypesCache.get_id_by_type_name(GameSerialType::TYPE_NAME_TRIAL)],
                :lock=>"LOCK IN SHARE MODE"
              )
            end
          end

          if online_order || offline_product_key || (trial_product_key && input_serial_type_name == GameSerialType::TYPE_NAME_TRIAL)
            err = I18n.t("ERRORS.ERROR_HAVE_BUY_GAME")
            raise ActiveRecord::Rollback
          end
    
          #
          # 保存注册的序列号信息

          input_serial_number.status = GameSerialNumber::STATUS_USED
          input_serial_number.save!

          user_game_serials = UserGameSerial.new
          user_game_serials.account_id = account_id
          user_game_serials.game_id = game_id
          user_game_serials.serial_number = serial_number
          user_game_serials.serial_type = input_serial_number.serial_type
          user_game_serials.save!


          # 查找游戏信息，返回时使用
          register_game = Game.find(
            :first,
            :select=>"name",
            :conditions=>["id=?", game_id],
            :lock=>"LOCK IN SHARE MODE"
          )
  
          if register_game == nil
            err = I18n.t("ERRORS.ERROR_GAME_NOT_FOUND")
            raise ActiveRecord::Rollback
          end
  
          err = allocate_missing_serial_types(account_id, game_id, input_serial_type_name)
          
          if err
             raise ActiveRecord::Rollback
          end  
        end
      rescue
        err = $!.to_s
      end
  
      
      if err == nil
        ret = {:status => "success", :data => {:game_name =>register_game.name} }
      else
        ret = { :status => "error", :message => I18n.t("ERRORS.ERROR_UNKNOW") }
      end
      
      render :json=>ret
    end
  end



  def get_game_news
    begin
      game_id = params[:game_id].to_i
      game_news_list = GameNews.find(
        :all,
        :conditions => ["game_id=:game_id", {:game_id => game_id}]
      );

      data = Array.new
      game_news_list.each do |item|
        data << {
          :title => item.title,
          :author_name => item.author_name,
          :summary => item.summary,
          :time => item.changed_time,
          :news_id => item.news_id,
          :image => item.image.gsub("public://", "http://#{SysParamsCache.get('MALL_HOME_PAGE')}/sites/default/files/"),
          :link => "http://#{SysParamsCache.get('MALL_HOME_PAGE')}/node/#{item.news_id}"
        }
      end
      ret = {:status => "success", :data => {:game_news => data} }
    rescue
      ret = { :status => "error", :message => I18n.t("ERRORS.ERROR_UNKNOW") }
    end

    render :json => ret
  end
  
  
  private
  
  # <b>分配缺失的序列号类型</b>
  #
  # 参数：
  #   account_id: 用户账户id
  #   game_id: 游戏id
  #   raw_serial_type_name: 平台序列号类型名，GameSerialType::TYPE_NAME_TRIAL, GameSerialType::TYPE_NAME_RETAIL, GameSerialType::TYPE_NAME_OFFLINE, GameSerialType::TYPE_NAME_ONLINE之一
  # 返回：err
  #   err: 错误，nil表示成功
  def allocate_missing_serial_types(account_id, game_id, raw_serial_type_name)
    err = nil
    
    serial_types = SerialType.find(
      :all,
      :select=>"id, type_name, type_desc",
      :lock=>"LOCK IN SHARE MODE"
    )

    serial_type_desc_hash = {}  # id -> type_desc
    serial_type_name_hash = {}  # type_name -> id

    serial_types.each do |serial_type|
      serial_type_desc_hash[serial_type.id] = serial_type.type_desc
      serial_type_name_hash[serial_type.type_name] = serial_type.id
    end


    # 待分配的KEY类型
    serial_types_to_allocate = GameSerialType.find(
      :all,
      :select => "serial_type",
      :conditions => ["game_id=:game_id", {:game_id => game_id}],
      :lock => "LOCK IN SHARE MODE"
    );

    serial_types_to_allocate = serial_types_to_allocate.collect{ |t| t.serial_type }
    serial_types_to_allocate << serial_type_name_hash[raw_serial_type_name] unless serial_types_to_allocate.include?(serial_type_name_hash[raw_serial_type_name])

    # 过滤掉需要排除的KEY类型
    exclude_key_types = GameSerialType::EXCULDE_KEY_TYPES_HASH[raw_serial_type_name]
    exclude_key_types.each do |exclude_key|
      serial_types_to_allocate.delete(serial_type_name_hash[exclude_key])
    end

    # 过滤掉已分配的序列号类型
    allocated_key_types = UserGameSerial.find(
      :all,
      :select=>"serial_type",
      :conditions=>["account_id=? AND game_id=?", account_id, game_id],
      :lock=>"LOCK IN SHARE MODE"
    )
    
    allocated_key_types.each do |item|
      serial_types_to_allocate.delete(item.serial_type)
    end

    ActiveRecord::Base.transaction do
      serial_types_to_allocate.each do |serial_type_info|
        # 查找此类型对应的可用序列号
        serial_number_available = GameSerialNumber.find(
          :first,
          :conditions =>["game_id=? AND status=? AND serial_type=?", game_id, GameSerialNumber::STATUS_FRESH, serial_type_info],
          :lock =>true
        )
      
        #if serial_number_available == nil
        #  err = I18n.t("ERRORS.ERROR_SERIAL_NUMBER_SHORTAGE", :serial_type=>serial_type_info)
        #  raise ActiveRecord::Rollback
        #end
        if serial_number_available
          # 修改状态为已使用
          serial_number_available.status = GameSerialNumber::STATUS_USED
          serial_number_available.save!
        
          # 保存用户序列号信息
          user_game_serials = UserGameSerial.new
          user_game_serials.account_id = account_id
          user_game_serials.game_id = game_id
          user_game_serials.serial_number = serial_number_available.serial_number
          user_game_serials.serial_type = serial_number_available.serial_type
          user_game_serials.save!
        end
      end
    end
    return err
  end
end
