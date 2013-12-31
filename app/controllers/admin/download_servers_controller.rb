# -*- encoding : utf-8 -*-
class Admin::DownloadServersController < AdminController
	
  # GET /admin_download_servers
  # GET /admin_download_servers.xml
  def index
    @download_servers = Admin::DownloadServer.all

    respond_to do |format|
      format.html # index.html.slim
      format.xml  { render :xml => @download_servers }
    end
  end

  # GET /admin_download_servers/1
  # GET /admin_download_servers/1.xml
  def show
    @download_server = Admin::DownloadServer.find(params[:id])

    respond_to do |format|
      format.html # show.html.slim
      format.xml  { render :xml => @download_server }
    end
  end

  # GET /admin_download_servers/new
  # GET /admin_download_servers/new.xml
  def new
    @download_server = Admin::DownloadServer.new

    respond_to do |format|
      format.html # new.html.slim
      format.xml  { render :xml => @download_server }
    end
  end

  # GET /admin_download_servers/1/edit
  def edit
    @download_server = Admin::DownloadServer.find(params[:id])
  end

  # POST /admin_download_servers
  # POST /admin_download_servers.xml
  def create
  
	if params[:admin_download_server][:server_ip] && params[:admin_download_server][:comment]
		@download_server = Admin::DownloadServer.new(params[:admin_download_server])
	else
		@download_server.errors[:base] << t('admin.errors.field_missing')
	end
    respond_to do |format|
      if @download_server.save
        format.html { redirect_to(admin_download_servers_path, :notice => 'Admin::DownloadServer was successfully created.') }
        format.xml  { render :xml => @download_server, :status => :created, :location => @download_server }
      else
        format.html {
          flash[:error] = @download_server.errors
          render :action => "new"
        }
        format.xml  { render :xml => @download_server.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin_download_servers/1
  # PUT /admin_download_servers/1.xml
  def update
    @download_server = Admin::DownloadServer.find(params[:id])

    respond_to do |format|
      if @download_server.update_attributes(params[:admin_download_server])
        format.html { redirect_to(admin_download_servers_path, :notice => 'Admin::DownloadServer was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html {
          flash[:error] = @download_server.errors
          render :action => "edit"
        }
        format.xml  { render :xml => @download_server.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin_download_servers/1
  # DELETE /admin_download_servers/1.xml
  def destroy
    @download_server = Admin::DownloadServer.find(params[:id])
    @download_server.destroy

    respond_to do |format|
      format.html { redirect_to(admin_download_servers_url) }
      format.xml  { head :ok }
    end
  end
end
