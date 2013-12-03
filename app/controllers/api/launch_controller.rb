require 'openssl'
require 'digest/sha1'
require 'base64'

class Api::LaunchController < ApplicationController
  def get_launcher
    crypt_type = params[:crypt_type].to_i
    version = params[:ver].to_i

    if @@launcher == nil
      init_launcher_cache
    end

    if @@launcher && @@launcher[crypt_type] && @@launcher[crypt_type][version]
      luancher = @@launcher[crypt_type][version]
      send_data luancher.launcher, :filename => luancher.launcher_name, :disposition => 'inline'
    else
      ret = { :status => "fail", :data => { :err => I18n.t("ERRORS.ERR_GAME_FILE_NOT_EXIST") } }
      return :json => ret
    end
  end

  private
  @@lock = Mutex.new
  @@launcher = nil

  def init_launcher_cache
    @@lock.synchronize do
      if @@launcher == nil  # Double check
        @@launcher = {}

        launchers = Launcher.all

        launchers.each do |l|
          if @@launcher[l.crypt_type] == nil
            @@launcher[l.crypt_type] = {}
          end

          @@launcher[l.crypt_type][l.ver] = l
        end
      end
    end
  end
end
