class CloudStoragesController < ApplicationController
  before_filter :sonkwo_authenticate_account, :except => [:create]
  protect_from_forgery :except => :create 

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
    account_id = params['account_id']
    upload_time = params['timestamp']
    sonkwo_token = Digest::MD5.hexdigest("#{account_id},#{upload_time},#{Settings.cloud_storage.sonkwo_key}")
    if sonkwo_token != params['sonkwo_token']
      ret = {:error => 'wrong token'}
      render :json => ret, :status => 501
    end
    # save the result
    storage = CloudStorage.new
    storage.account_id = account_id
    storage.bucket_name = Settings.cloud_storage.avatar_buchekt
    storage.key = params['hash']
    # TODO
    #storage.data = 
    storage.save!
    dest_url = "http://#{Settings.cloud_storage.avatar_buchekt}.u.qiniudn.com/#{params['hash']}"
    ret = {:dest_url => dest_url}
    render :json => ret, :status => 200
  end
end
