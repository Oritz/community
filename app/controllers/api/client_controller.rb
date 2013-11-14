# -*- encoding : utf-8 -*-
class Api::ClientController < ApplicationController
  before_filter :sonkwo_authenticate_account, :only => :post_err_msg
    
  def post_err_msg
    account_id = current_account.id
    err_msg =  params[:err_msg]
    
    ret =nil 
    
    if request.post?
      begin
        client_errors = ClientError.new(
          :account_id =>account_id,
          :err_msg =>err_msg
        )
        
        client_errors.save
      rescue
        puts $!.inspect
        puts $!.backtrace    
        err = $!.inspect
      end
      
      if err
        ret = {:result =>RET_FAILED, :err =>err}
      else
        ret = {:result =>RET_SUCCESS}
      end 
   
    end
    
    render(:json => ret)
  end
  
  
  def get_client_version
  
    major_ver = params[:major_ver]
    minor_ver = params[:minor_ver]
    tiny_ver = params[:tiny_ver]
    new_vers = []
    
    if major_ver && minor_ver && tiny_ver
      #以下三种情况的查询所有的大于当前版本的版本号，并按照升序排列
      new_major_ver = ClientUpdate.find(
        :all,
        :select =>"major_ver, minor_ver, tiny_ver",
        :order =>"created_at",
        :conditions =>["major_ver > ? AND status =?", major_ver, ClientUpdate::STATUS_RELEASED]
      )
      new_minor_ver = ClientUpdate.find(
        :all,
        :select =>"major_ver,minor_ver,tiny_ver",
        :order =>"created_at",
        :conditions =>["major_ver = ? AND minor_ver > ? AND status =?", major_ver, minor_ver, ClientUpdate::STATUS_RELEASED]
      )    
      new_tiny_ver = ClientUpdate.find(
        :all,
        :select =>"major_ver,minor_ver,tiny_ver",
        :order =>"created_at",
        :conditions =>["major_ver = ? AND minor_ver = ? AND tiny_ver > ? AND status =?", major_ver, minor_ver, tiny_ver, ClientUpdate::STATUS_RELEASED]
      )    
      
      if new_tiny_ver
        new_tiny_ver.each do |m|
          new_vers.push([m.major_ver, m.minor_ver, m.tiny_ver])
        end
      end
      
      if new_minor_ver
        new_minor_ver.each do |m|
          new_vers.push([m.major_ver, m.minor_ver, m.tiny_ver])
        end
      end
      
      
      if new_major_ver
        new_major_ver.each do |m|
          new_vers.push([m.major_ver, m.minor_ver, m.tiny_ver])
        end
      end      
      
      
      if new_vers[0]
        ret = { :result=>RET_SUCCESS, :ver=>new_vers }
      else
        ret = { :result=>RET_SUCCESS, :ver=>nil }
      end
      
      
    else
      ret = { :result=>RET_FAILED}
    end
    
    render :json=>ret
  end
  
  def get_latest_client_version
    
    latest_client_version = ClientUpdate.find(
      :first,
      :select =>"major_ver, minor_ver, tiny_ver",
      :order =>"created_at DESC",
      :conditions =>["status =?", ClientUpdate::STATUS_RELEASED]
    )
    
    if latest_client_version
      ret = { :result=>RET_SUCCESS, :major_ver=>latest_client_version.major_ver, :minor_ver => latest_client_version.minor_ver, :tiny_ver =>latest_client_version.tiny_ver }
    else
      err = "can not find any client versions"
      ret = { :result=>RET_FAILED, :err=>err }
    end
    
    render :json=>ret
  end
  
  
  def get_patch
    
    major_ver = params[:major_ver]
    minor_ver = params[:minor_ver]
    tiny_ver = params[:tiny_ver]
    
    client_version =  ClientUpdate.find(
      :first,
      :select =>"patch_file",
      :conditions =>["major_ver =? AND minor_ver=? AND tiny_ver =?", major_ver, minor_ver, tiny_ver]
    )
    

    if client_version
      send_file(client_version.patch_file)
    else
      err = I18n.t("ERRORS.ERR_CLIENT_NOT_FOUND")
      ret = {:result=>RET_FAILED, :err=>err }
      render :json => ret
    end
  end
  
  def get_full_pkg

    major_ver = params[:major_ver]
    minor_ver = params[:minor_ver]
    tiny_ver = params[:tiny_ver]
    
    client_version =  ClientUpdate.find(
      :first,
      :select =>"full_pkg_file",
      :conditions =>["major_ver =? AND minor_ver=? AND tiny_ver =?", major_ver, minor_ver, tiny_ver]
    )

    if client_version
      send_file(client_version.full_pkg_file)
    else
      err = I18n.t("ERRORS.ERR_CLIENT_NOT_FOUND")
      ret = {:result=>RET_FAILED, :err=>err }
      render :json => ret
    end
    
  end

  def get_client_desc

    major_ver = params[:major_ver]
    minor_ver = params[:minor_ver]
    tiny_ver = params[:tiny_ver]

    client =  ClientUpdate.find(
      :first,
      :select =>"description",
      :conditions =>["major_ver =? AND minor_ver=? AND tiny_ver =?", major_ver, minor_ver, tiny_ver]
    )

    if client
      send_data(client.description, :type => "application/zip", :stream=>'true', :filename => "client_description.txt" )
    else
      err = I18n.t("ERRORS.ERR_CLIENT_NOT_FOUND")
      ret = {:result=>RET_FAILED, :err=>err }
      render :json => ret
    end

  end
  
  private
  
  #判断上传版本是否高于现有的版本
  def valid_version?(upload_ver,lastest_ver)
    result = false
    
    [0,1,2].each do |i|
      if upload_ver[i].to_i > lastest_ver[i].to_i
        result = true
        break
      end
    end
    
    return result
  end
  
  #判断上传版本是为待更新版本
  def latest_version?(upload_ver,latest_ver)
    result = true
    
    [0,1,2].each do |i|
      unless upload_ver[i].to_i == latest_ver[i].to_i
        result = false
        break
      end
    end
    
    return result
  end
  
end
