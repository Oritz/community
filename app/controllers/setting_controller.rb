require 'pathname'
require 'openid'
require 'openid/store/filesystem'

class SettingController < ApplicationController
  before_filter :sonkwo_authenticate_account

  def security
  end

  def account
  end

  def bind
    begin
      identifier = "http://steamcommunity.com/openid"
      oidreq = consumer.begin(identifier)
    rescue OpenID::OpenIDError => e
      flash[:error] = "Bind failed"
      redirect_to action: security
    end

    return_to = url_for action: 'bind_complete', only_path: false
    realm = url_for action: 'index', id: nil, only_path: false

    if oidreq.send_redirect?(realm, return_to, nil)
      redirect_to oidreq.redirect_url(realm, return_to, nil)
    else
      render text: "failed"
    end
  end

  def bind_complete
    current_url = url_for action: 'bind_complete', only_path: false
    parameters = params.reject { |k,v| request.path_parameters[k] }
    parameters.reject! { |k,v| %w{action controller}.include? k.to_s }
    oidresp = consumer.complete(parameters, current_url)
    case oidresp.status
    when OpenID::Consumer::FAILURE
      flash[:error] = "Bind failed: #{oidresp.message}"
    when OpenID::Consumer::SUCCESS
      display_identifier = oidresp.display_identifier
      header_length = "http://steamcommunity.com/openid/id/".length
      length = display_identifier.length
      claimed_id = display_identifier[header_length..length]
      p claimed_id
      if claimed_id.to_i.to_s == claimed_id
        steam_user = SteamUser.where(steamid: claimed_id).first
        need_worker = steam_user ? false : true
        steam_user = SteamUser.new(steamid: claimed_id) unless steam_user

        # check if current_account is binded
        # unbind current_account first
        if current_account.steam_user && current_account.steam_user != steam_user
          original_steam_user = current_account.steam_user
          original_steam_user.account = nil
          original_steam_user.save!
        end

        steam_user.account = current_account
        steam_user.save!

        # add a worker
        FetchSteamUserWorker.perform_async(steam_user.steamid) if need_worker
        #FetchSteamUserWorker.perform_async(steam_user.steamid)

        flash[:success] = "Bind succeeded."
      else
        flash[:error] = "Bind failed"
      end
    when OpenID::Consumer::CANCEL
      flash[:alert] = "Bind cancelled."
    else
    end
    redirect_to action: 'security'
  end

  private
  def consumer
    if @consumer.nil?
      dir = Pathname.new(Rails.root).join('db').join('cstore')
      store = OpenID::Store::Filesystem.new(dir)
      @consumer = OpenID::Consumer.new(session, store)
    end
    return @consumer
  end
end
