class CloudStoragesController < ApplicationController
  before_filter :sonkwo_authenticate_account, :except => [:create]
  protect_from_forgery :except => :create
  layout false

  def create
    # TODO: ONLY allow from qiniu server!
    # TODO: Add try catch!
    # check token
    account = Account.where(id: params[:account_id].to_i).first
    unless account
      ret = {error: 'wrong account_id'}
      render json: ret, status: 501
    end

    upload_time = params['timestamp']
    sonkwo_token = Digest::MD5.hexdigest("#{account.id},#{upload_time},#{Settings.cloud_storage.sonkwo_key}")
    if sonkwo_token != params['sonkwo_token']
      ret = {error: 'wrong token'}
      render json: ret, status: 501
    end
    # save the result
    storage = CloudStorage.new
    storage.account = account
    storage.bucket_name = params['bucket_name']
    storage.key = params['hash']

    # TODO
    #storage.data
    storage.save!

    callback_params = {account: account}
    if proccess(params[:sonkwo_callback], storage, callback_params)
      ret = {dest_url: storage.url, storage_id: storage.id, img_name: params['name']}
      render json: ret, status: 200
    else
      render json: { status: "error", message: @error_message }
    end
  end

  private
  def proccess(callback, storage, opts)
    case callback
    when "updateavatar"
      opts[:account].avatar = storage.url+"_l"
      if opts[:account].save
        return true
      else
        @error_message = I18n.t("account.update_avatar_failed")
        return false
      end
    else
    end

    true
  end
end
