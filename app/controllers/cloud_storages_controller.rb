class CloudStoragesController < ApplicationController
  before_filter :sonkwo_authenticate_account, :except => [:create]
  protect_from_forgery :except => :create 
  
  AVATAR_BUCHEKT = 'sonkwo-avatar'
  SNAPSHOT_BUCKET = 'sonkwo-snapshot'
  SONKWO_KEY = 'dsfa1315zasfz989-77'
  
  TOKEN_EXPIRE = 60                # default 3600. expires time of upload url, in secoinds
  CALLBACK_URL =  'http://101.71.243.50:8006/cloud_storages'  # 301 header url if upl success

  # post data, x:account_id, x:sonkwo_token and x:timestamp are our variables
  CALLBACK_BODY =  'name=$(fname)&size=$(fsize)&w=$(imageInfo.width)&h=$(imageInfo.height)&hash=$(etag)&sonkwo_token=$(x:sonkwo_token)&account_id=$(x:account_id)&timestamp=$(x:timestamp)' 
  CALLBACK_BODY_TYPE = 'application/x-www-form-urlencoded'
  ESCAPE = 1          # we don't using escape character
  ASYNC_OPTIONS= ''
  RETURN_BODY = '{
    "foo": "bar", 
    "size": $(fsize), 
    "hash": $(etag), 
    "w": $(imageInfo.width), 
    "h": $(imageInfo.height), 
    "color": $(exif.ColorSpace.val),
    "sonkwo_token": $(x:sonkwo_token),
    "account_id": $(x:account_id),
    "timestamp": $(x:timestamp)
    
  }'

  
  def index
  end
  
  def new
    # generate our md5 hash
    @now_time = Time.now.to_i
    @sonkwo_token = Digest::MD5.hexdigest("#{current_account.id},#{@now_time},#{SONKWO_KEY}")
    
    # default avatar bucket: AVATAR_BUCHEKT
    @upload_token = Qiniu::RS.generate_upload_token(:scope  => AVATAR_BUCHEKT,
                                :expires_in         => TOKEN_EXPIRE,
                                :callback_url       => CALLBACK_URL,
                                :callback_body      => CALLBACK_BODY,
                                :callback_body_tpye => CALLBACK_BODY_TYPE,
                                :customer           => current_account.id.to_s,
                                :escape             => ESCAPE,
                                :async_options      => ASYNC_OPTIONS,
                                :return_body        => RETURN_BODY)
                                
  end
  
  def create
    # TODO: ONLY allow from qiniu server!
    # TODO: Add try catch!
    
    # check token
    account_id = params['account_id']
    upload_time = params['timestamp']
    sonkwo_token = Digest::MD5.hexdigest("#{account_id},#{upload_time},#{SONKWO_KEY}")
    if sonkwo_token != params['sonkwo_token']
      ret = {:error => 'wrong token'}
      render :json => ret, :status => 501
    end
    
    # save the result
    storage = CloudStorage.new
    storage.account_id = account_id
    storage.bucket_name = AVATAR_BUCHEKT
    storage.key = params['hash']
    # TODO
    #storage.data = 
    storage.save!
    
    dest_url = "http://#{AVATAR_BUCHEKT}.u.qiniudn.com/#{params['hash']}"
    ret = {:dest_url => dest_url}
    render :json => ret, :status => 200
    
  end

  def show
  end
  
  def edit
  end
  
  def update
  end
  
  def detroy
  end
  
end
