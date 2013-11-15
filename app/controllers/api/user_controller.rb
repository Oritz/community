# -*- encoding : utf-8 -*-
#require 'cache/ext_platform_cache'
class Api::UserController < ApplicationController
  before_filter :sonkwo_authenticate_account

  def index
    begin
      @account = current_account
      unless @account
        render_404
        return
      end
      
      tmp = ActiveRecord::Base.connection.select_one("SELECT email, authmap.uid FROM accounts INNER JOIN authmap ON authname=email WHERE accounts.id=#{current_account.id}")
      if tmp.nil? || tmp.empty?
        @order_count = 0
      else
        uid = tmp["uid"]
        @order_count = ActiveRecord::Base.connection.select_one("SELECT count(order_id) FROM uc_orders WHERE uid=#{uid} AND order_status='completed'")
        @order_count = @order_count["count(order_id)"]
      end

      product_keys = ["TYPE_OFFLINE_PRODUCT_KEY", "TYPE_ONLINE_PRODUCT_KEY", "TYPE_RETAIL_PRODUCT_KEY"]
      @game_count = UserGameSerial.joins("INNER JOIN serial_types ON serial_types.id=user_game_serials.serial_type").where(["type_name in (?) AND account_id=?", product_keys, current_account.id]).select("game_id").count
      
      @platform = {}
      @ext_ids = UserExtId.where(["account_id=?", current_account.id]).select("ext_platform, ext_id").all
      ext_platforms = ExtPlatformCache.find_all
      ext_platforms.each do |key, value|
        @platform[key] = {'display' => value['display']}
        @ext_ids.each do |ext|
          if ext.ext_platform == key
            @platform[key]["ext_id"] = ext.ext_id
            break
          end
        end
      end
    #rescue
    #  render_500
    end
  end

  def games
    begin
      @account = Account.find(current_account.id)
      unless @account
        render_404
        return
      end

      @count_perpage = 20
      @page_count = (params[:page] || 1).to_i
      product_keys = ["TYPE_OFFLINE_PRODUCT_KEY", "TYPE_ONLINE_PRODUCT_KEY", "TYPE_RETAIL_PRODUCT_KEY"]
      @games = UserGameSerial.joins("INNER JOIN serial_types ON serial_types.id=user_game_serials.serial_type INNER JOIN games ON game_id=games.id").where(["type_name in (?) AND account_id=?", product_keys, current_account.id]).select("game_id, games.name, type_name").paginate(:page => params[:page], :per_page => @count_perpage)
    rescue
      render_500
    end
  end

  def orders
    begin
      @account = Account.find(current_account.id)
      unless @account
        render_404
        return
      end

      @count_perpage = 20
      @page_count = (params[:page] || 1).to_i


      tmp = ActiveRecord::Base.connection.select_one("SELECT email, authmap.uid FROM accounts INNER JOIN authmap ON authname=email WHERE accounts.id=#{current_account.id}")
      if tmp.nil? || tmp.empty?
        @orders = []
      else
        uid = tmp["uid"]
        @orders = UcOrder.where(["uid=? AND order_status=?", uid, 'completed']).select("order_id, order_total, created, order_status").order("created DESC").paginate(:page => params[:page], :per_page => @count_perpage)
      end
    rescue
      render_500
    end
  end

  def order
    tmp = ActiveRecord::Base.connection.select_one("SELECT email, authmap.uid FROM accounts INNER JOIN authmap ON authname=email WHERE accounts.id=#{current_account.id}")
      if tmp.nil? || tmp.empty?
        respond_to do |format|
          format.json { render :json => {:result => RET_FAILED} }
        end
      else
        uid = tmp["uid"]
        order_id = params[:order_id].to_i
        order = ActiveRecord::Base.connection.select_one("SELECT uid FROM uc_orders WHERE order_id=#{order_id} AND uid=#{uid}")
        if order.nil? || order.empty?
          respond_to do |format|
            format.json { render :json => {:result => RET_FAILED} }
          end
        else
          products = ActiveRecord::Base.connection.select_all("SELECT nid, title, price FROM uc_order_products WHERE order_id=#{order_id}")
          coupons = ActiveRecord::Base.connection.select_all("SELECT code, value FROM uc_coupons_orders WHERE oid=#{order_id}")

          respond_to do |format|
            format.json { render :json => {:result => RET_SUCCESS, :products => products, :coupons => coupons} }
          end
        end
      end
  end

  def security
    begin
      @account = Account.find(current_account.id)
      unless @account
        render_404
        return
      end
    rescue
      render_500
    end
  end

  def photo
    @account = current_account
    unless @account
      render_404
      return
    end
    if !request.get?
      if(session[:is_upload_avatar])
        render :json => { :result => RET_FAILED }
        return
      end

      session[:is_upload_avatar] = true
      @account.avatar = params[:account][:avatar]
      
      if @account.errors[:avatar].blank?
        # return text format because of IE will download the .json file if the server returns json data
        render :text => { :result => RET_SUCCESS, :url => @account.avatar.url, :avatar_cache => @account.avatar_cache }.to_json
      else
        error = @account.errors[:avatar].empty? ? "" : @account.errors[:avatar][0]
        render :json => { :result => RET_FAILED, :error => error }
      end
      session[:is_upload_avatar] = false
    end
  end

  def avatarcrop
    account = current_account
    account.crop_x = params[:account][:crop_x]
    account.crop_y = params[:account][:crop_y]
    account.crop_w = params[:account][:crop_w]
    account.crop_h = params[:account][:crop_h]
    if(!params[:new_avatar].blank?)
      account.avatar = File.open(account.avatar.file_path(params[:new_avatar]))
    else
      if account.avatar.url == account.avatar.default_url
        render_500
        return
      end
      account.avatar.recreate_versions!
    end
    account.save!

    redirect_to :action => :photo
  end

  # 用户行为上传
  def post_action
    ret = {:status => "error", :message => "request method is expected post."}
    if request.post?
      account_id = current_account.id
      begin
        ActiveRecord::Base.transaction do
          if params[:file] != nil
            # 约定每个action以\r\n分割
            actions = params[:file].split("\r\n")

            actions.each do |every_acts|
              acts = every_acts.split(',')

              user_action = UserAction.new
              user_action.account_id = account_id
              user_action.created_at = Time.at(acts[2].to_i)
              user_action.action_type = acts[0]
              user_action.object_name = acts[1]
              user_action.save!

              ret = {:status => "success", :data => nil}
            end
          end
        end
      rescue
        ret = { :status => "error", :message => I18n.t("ERRORS.ERROR_UNKNOW") }
      end
      render :json=>ret
    end
  end

  # 用户硬件信息上传
  def update_env
    if request.post?
      env = UserEnv.new

      env_data = ActiveSupport::JSON.decode params[:data]
      # 创建临时对象并加上account_id属性
      temp_env = env_data.merge({:account_id => current_account.id})

      if env.update_attributes(temp_env)
        ret = {:status => "success", :data => nil}
      else
        ret = {:status => "fail", :data => nil}
      end
      render :json=>ret
    end
  end

  # 游戏存档的上传
  def update_profile
    if request.post?
      profile = PlayerProfile.new
      profile.account_id = current_account.id
      profile.game_id = params[:game_id]
      profile.profile_name = params[:profile_name]
      profile.profile_content = params[:file].read

      if profile.save
        ret = {:status => "success", :data => nil}
      else
        ret = {:status => "fail", :data => nil}
      end
    end

    render :json=>ret
  end

  # 游戏存档的下载
  #def download_profile
  #  profile = nil
  #  profile =  PlayerProfile.find(
  #  :all,
  #  :conditions =>["account_id=? and game_id=?",current_account.id,params[:game_id]]
  #  )

  #  ret = profile[0].profile_content

  #  send_data(ret, :type => "application/zip", :stream=>'true' )
  # 可选添加属性, :filename => "sample.xml",:dispostion=>'inline',:status=>'200 OK'
  #end

  # 获取登录玩家某个游戏的花费时间
  def get_play_time
    game_id = params[:game_id]

    begin
    # 最后玩游戏时间
      last_time = UserGamePlayHistory.find(
      :first,
      :select => "UNIX_TIMESTAMP(start_time) AS start_timestamp",
      :conditions => ["account_id=? AND game_id=?", current_account.id, game_id],
      :order => "start_time DESC"
      )

      # 总计时间
      all_log = UserGamePlayHistory.find(
      :all,
      :select =>"SUM(UNIX_TIMESTAMP(exit_time)-UNIX_TIMESTAMP(start_time)) AS total_time",
      :conditions =>["account_id=? AND game_id=?", current_account.id, game_id]
      )

      # 最近一周时间
      week_log = UserGamePlayHistory.find(
      :all,
      :select =>"SUM(UNIX_TIMESTAMP(exit_time)-UNIX_TIMESTAMP(start_time)) AS total_time",
      :conditions =>["account_id=? AND game_id=? AND start_time>=NOW()-INTERVAL 7 DAY", current_account.id, game_id]
      )

      last_run_time = last_time ? last_time.start_timestamp : -1

      ret = {:status => "success", :data => {:last_run_time =>last_run_time, :total_time =>all_log[0].total_time ? all_log[0].total_time.to_i : 0, :week_total_time =>week_log[0].total_time ? week_log[0].total_time.to_i : 0} }
    rescue
      ret = { :status => "error", :message => I18n.t("ERRORS.ERROR_UNKNOW") }
    end

    render :json =>ret
  end

  # 获取用户的外部平台绑定信息
  def list_ext_ids
    if params[:ext_platform]
      @ext_platform = params[:ext_platform]
      @special_ext_platform = true
    else
      @special_ext_platform = false
      @ext_platforms = ExtPlatformCache.find_all
    end
    @user_ext_ids = UserExtId.find_all_by_account_id(current_account.id)
  end

  # 绑定外部平台帐号
  def bind_ext_id
    account_id = current_account.id
    ext_platform = params[:ext_platform].strip
    ext_id = params[:ext_id].strip

    ret = nil

    begin
      if request.post?
        ActiveRecord::Base.transaction do
          bind_info = UserExtId.find(
          :first,
          :conditions=>["account_id=? AND ext_platform=?", account_id, ext_platform],
          :lock=>true
          )

          if bind_info == nil && ext_id != ""
            bind_info = UserExtId.new(
            :account_id=>account_id,
            :ext_platform=>ext_platform
          )
          end

          if bind_info && bind_info.ext_id != ext_id
            bind_info.ext_id = ext_id
            bind_info.save!

            achievements = PlayerAchievement.find(
              :all,
              :select => "player_achievements.id",
              :joins => ",game_achievements, game_ext_ids",
              :conditions => ["game_achievements.id=player_achievements.game_achievement_id AND game_ext_ids.game_id=game_achievements.game_id AND account_id=:account_id AND game_ext_ids.ext_platform=:ext_platform", {:account_id => account_id, :ext_platform => ext_platform}]
            )

            ids = []
            achievements.each do |o|
              ids << o.id
            end

            #删除旧成就
            PlayerAchievement.delete(ids)
          end
        end

        ret = {:result => RET_SUCCESS}
      end
    rescue
      ret = {:result => RET_FAILED}
    end
    render :json => ret
  end
end
