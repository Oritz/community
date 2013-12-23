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

	# GET /admin_client_versions/1/edit
	def edit
		@client = ClientUpdate.find(params[:id])
	end

	# POST /admin_client_versions
	# POST /admin_client_versions.xml
	def create
		@client = ClientUpdate.new
		begin
		
			if	params[:full_pkg] && params[:desc]

				full_pkg = params[:full_pkg][0]
				full_name = full_pkg.original_filename
				description = params[:desc][0]
				@client.description = description.read
				
				if full_name.index("_") && File.extname(full_name) == ".msi"
					full_pkg_name = full_name.split("_")[1]
					upload_full_pkg_ver = full_pkg_name.split(".")					
				else
					ActiveRecord::Base.errors.add(@client, t('admin.error.client_name_format_error'))
				end				
				
				latest_version = ClientUpdate.maximum('id')
				if !latest_version
					latest_ver_number = [0, 0, 0]
				else
					client = ClientUpdate.select('major_ver, minor_ver, tiny_ver').where('id=?', latest_version).first
					latest_ver_number = [client.major_ver, client.minor_ver, client.tiny_ver]
				end
				
				1.times do
					if valid_version?(upload_full_pkg_ver, latest_ver_number)
						@client.major_ver = upload_full_pkg_ver[0] 
						@client.minor_ver = upload_full_pkg_ver[1]
						@client.tiny_ver = upload_full_pkg_ver[2] 
						
						full_name_number = full_name.split(".ms")[0].split("_")[1]
						full_pkg_file = ClientFile.new(full_name_number,'full_pkg_file', full_pkg)
						full_pkg_file.save
						
						@client.status =  ClientUpdate::STATUS_RELEASED
						@client.full_pkg_file = full_pkg_file.client_path
						@client.full_pkg_digest = full_pkg_file.client_digest
					else
						@client.errors[:base] << t('admin.error.newer_version_exsit')
						break
					end

					if params[:patch]
						patch = params[:patch][0]
						patch_name = params[:patch][0].original_filename
						
						 patch_name_number = patch_name.split(".ms")[0].split("_")[1]
						 
						if patch_name_number == full_name_number

							patch_file = ClientFile.new(full_name_number, "patch_file", params[:patch][0])
							patch_file.save
					
							@client.patch_file = patch_file.url
						else
							@client.errors[:base] << t('admin.error.full_pkg_and_patch_not_at_same_version')
						end
					end
				end
			else
				@client.errors[:base] << t('admin.error.field_missing')
			end
		


			if @client.errors.size == 0 && @client.save!
				redirect_to(admin_clients_path, :notice => t('admin.msg.success'))
      else
        flash[:error] = @client.errors
				render(:action => 'new')
			end
		rescue
			puts $!.inspect
			puts $!.backtrace
		end
	end

	# PUT /admin_client_versions/1
	# PUT /admin_client_versions/1.xml
	def update
		@client = ClientUpdate.find(params[:id])
		begin
		
			if	params[:full_pkg]
				
				full_pkg = params[:full_pkg][0]
				full_name = params[:full_pkg][0].original_filename

				full_pkg_name = full_name.split("_")[1]
				upload_full_pkg_ver = full_pkg_name.split(".")
				
				latest_version = ClientUpdate.maximum('id')
				
				client = ClientUpdate.find(
					:first,
					:select =>"major_ver, minor_ver, tiny_ver",
					:conditions =>["id =?", latest_version]
				)
					
				if client
					latest_ver_number = [client.major_ver, client.minor_ver, client.tiny_ver]
				else
					latest_ver_number = [0, 0, 0]
				end
				
				
				1.times do
				
					if latest_version?(upload_full_pkg_ver, latest_ver_number)
						
						full_name_number = full_name.split(".ms")[0].split("_")[1]

					
						full_pkg_file = ClientFile.new(full_name_number,"full_pkg_file", full_pkg)
						full_pkg_file.save

					else
						@client.errors[:base] << '历史版本完整客户端不可修改'
						break
					end

					if params[:patch]
						patch = params[:patch][0]
						patch_name = params[:patch][0].original_filename
						
						 patch_name_number = patch_name.split(".ms")[0].split("_")[1]
						 
						if latest_version?(patch_name_number, full_name_number)

							patch_file = ClientFile.new(patch_name_number, "patch_file", params[:patch][0])
							patch_file.save
					
						else
							@client.errors[:base] << '历史版本更新包不可修改'
						end
					end
					
				end
				
			else
				@client.errors[:base] << '*标注的不能为空'
			end
	
		rescue
			puts $!.inspect
			puts $!.backtrace
		end
		
		
		respond_to do |format|
			if @client.errors.size > 0
				format.html { render :action => "edit" }
				format.xml { render :xml => @client.errors, :status => :unprocessable_entity }
			else
				format.html { redirect_to(edit_admin_client_version_path(@client), :notice => 'Client was successfully updated.') }
				format.xml { head :ok }
			end
		end
	end

	# DELETE /admin_client_versions/1
	# DELETE /admin_client_versions/1.xml
	def destroy
	
		@client = ClientUpdate.find(params[:id])
		
		if @client.patch_file
			@client.patch.delete
		end
		
		@client.full_pkg.delete
	
		@client.destroy

		respond_to do |format|
			format.html { redirect_to(admin_client_versions_url) }
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
