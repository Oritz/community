class CloudStoragesController < ApplicationController
  before_filter :sonkwo_authenticate_account, :except => [:create]
  protect_from_forgery :except => :create 

  layout false
  def index
  end

  def new
    # generate our md5 hash
    @now_time = Time.now.to_i
    @sonkwo_token = Digest::MD5.hexdigest("#{current_account.id},#{@now_time},#{Settings.cloud_storage.sonkwo_key}")

    # default avatar bucket: AVATAR_BUCHEKT
    @upload_token = Qiniu::RS.generate_upload_token(
                                :scope  => Settings.cloud_storage.avatar_bucket,
                                :expires_in         => Settings.cloud_storage.token_expire,
                                :callback_url       => Settings.cloud_storage.callback_url,
                                :callback_body      => Settings.cloud_storage.callback_body,
                                :callback_body_tpye => Settings.cloud_storage.callback_body_type,
                                :customer           => current_account.id.to_s,
                                :escape             => Settings.cloud_storage.escape,
                                :async_options      => Settings.cloud_storage.async_options,
                                :return_body        => Settings.cloud_storage.return_body)
  end

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
    sonkwo_token = Digest::MD5.hexdigest("#{account_id},#{upload_time},#{Settings.cloud_storage.sonkwo_key}")
    if sonkwo_token != params['sonkwo_token']
      ret = {error: 'wrong token'}
      render json: ret, status: 501
    end
    # save the result
    storage = CloudStorage.new
    storage.account = account
    storage.bucket_name = Settings.cloud_storage.avatar_buchekt
    storage.key = params['hash']
    # TODO
    #storage.data
    storage.save!
    ret = {dest_url: storage.url, storage_id: storage.id}
    render json: ret, status: 200
  end
end
