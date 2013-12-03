# -*- coding: utf-8 -*-
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
        err = $!.inspect
      end
      
      if err
        ret = { status: "fail", data: { err: err } }
      else
        ret = { status: "success", data: {} }
      end
   
    end
    
    render(:json => ret)
  end
  
  def get_latest_client_version
    
    latest_client_version = ClientUpdate.find(
      :first,
      :select =>"major_ver, minor_ver, tiny_ver",
      :order =>"created_at DESC",
      :conditions =>["status =?", ClientUpdate::STATUS_RELEASED]
    )
    
    if latest_client_version
      ret = { :status => "success", :data => {:major_ver=>latest_client_version.major_ver, :minor_ver => latest_client_version.minor_ver, :tiny_ver =>latest_client_version.tiny_ver }}
    else
      err = "can not find any client versions"
      ret = { :status => "fail", :data => {:err=>err} }
    end
    
    render :json=>ret
  end
end
