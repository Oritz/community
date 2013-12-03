# -*- encoding : utf-8 -*-
class Api::UserController < ApplicationController
  before_filter :sonkwo_authenticate_account

  # 用户行为上传
  def post_action
    if request.post?
      ret = {:status => "fail", :data => {:err => I18n.t("ERRORS.ERROR_UNKNOW")} }
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

              ret = {:status => "success", :data => {}}
            end
          end
        end
      rescue
        ret = { :status => "fail", :data => {:err => I18n.t("ERRORS.ERROR_UNKNOW")} }
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
        ret = {:status => "success", :data => {}}
      else
        ret = {:status => "fail", :data => {}}
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
        ret = {:status => "success", :data => {}}
      else
        ret = {:status => "fail", :data => {}}
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
      ret = { :status => "fail", :data => { :err => I18n.t("ERRORS.ERROR_UNKNOW") }}
    end

    render :json =>ret
  end
end
