# -*- encoding : utf-8 -*-

require 'digest/sha1'
require 'common/client_file'
require "common/common_page"
include CommonPage


class Admin::ClientsController < AdminController
	
	# GET /admin_client_versions
	# GET /admin_client_versions.xml
	def index
		@admin_clients = ClientUpdate.all

		respond_to do |format|
			format.html # index.html.slim
			format.xml	{ render :xml => @admin_clients }
		end
	end


	# GET /admin_client_versions/new
	# GET /admin_client_versions/new.xml
	def new
		@client = ClientUpdate.new

		respond_to do |format|
			format.html # new.html.slim
			format.xml	{ render :xml => @client }
		end
	end

	# POST /admin_client_versions
	# POST /admin_client_versions.xml
	def create
		@client = ClientUpdate.new(params[:client_update])
    respond_to do |format|
      if @client.errors.empty? && @client.save!
        format.html { redirect_to(admin_clients_path, :notice => t('admin.msg.success')) }
      else
        flash[:alert] = @client.errors[:base]
        format.html { render :action => 'new'}
      end
    end
	end

	# DELETE /admin_client_versions/1
	# DELETE /admin_client_versions/1.xml
	def destroy
    @client = ClientUpdate.find(params[:id])
    @client.destroy

		respond_to do |format|
			format.html { redirect_to(admin_clients_path, :notice => t('admin.msg.success')) }
			format.xml { head :ok }
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
	
	def validate_idt
		err = AdminController.validate_identity(session[:admin_identity], Role::ID_CLIENT_MANAGE)
		unless	err == nil
			puts "~~~~~~~~~~~~~~~~~~~~~~~~~have no right "
			render(:text => err)
		end
	end
end
