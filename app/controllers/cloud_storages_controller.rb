class CloudStoragesController < ApplicationController
  before_filter :sonkwo_authenticate_account, :except => [:create]
  protect_from_forgery :except => :create
  layout false

  def template
    render json: {status: "success", data: MustacheTemplate.upload_image}
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

    respond_to do |format|
      format.html
      format.json { render json:
        { status: "success", data: {
            upload_token: @upload_token,
            account_id: current_account.id,
            now_time: @now_time,
            sonkwo_token: @sonkwo_token,
            bucket_name: (params[:bucket_name] ||= Settings.cloud_storage.default_bucket)
          }
        }
      }
    end
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
    sonkwo_token = Digest::MD5.hexdigest("#{account.id},#{upload_time},#{Settings.cloud_storage.sonkwo_key}")
    if sonkwo_token != params['sonkwo_token']
      ret = {error: 'wrong token'}
      render json: ret, status: 501
    end
    # save the result
    storage = CloudStorage.new
    storage.account = account
    storage.bucket_name = Settings.cloud_storage.avatar_bucket
    storage.key = params['hash']

    # TODO
    #storage.data
    storage.save!

    if proccess(params[:sonkwo_callback], storage, account: account)
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
