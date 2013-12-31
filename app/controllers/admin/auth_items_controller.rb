class Admin::AuthItemsController < AdminController
  # GET /admin/auth_items
  # GET /admin/auth_items.json
  def index
    @actived_type = params[:auth_type] || AuthItem::TYPE_ROLE
    @roles = AuthItem.roles
    @operations = AuthItem.operations
    @tasks = AuthItem.tasks

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @admin_auth_items }
    end
  end

  # GET /admin/auth_items/1
  # GET /admin/auth_items/1.json
  def show
    @admin_auth_item = AuthItem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @admin_auth_item }
    end
  end

  # GET /admin/auth_items/new
  # GET /admin/auth_items/new.json
  def new
    auth_type = params[:auth_type]
    @auth_item = AuthItem.new(:auth_type => auth_type)
    filter_auth_type(auth_type)

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @admin_auth_item }
    end
  end

  # GET /admin/auth_items/1/edit
  def edit
    @auth_item = AuthItem.find(params[:id])
    filter_auth_type(@auth_item.auth_type)
  end

  # POST /admin/auth_items
  # POST /admin/auth_items.json
  def create
    @admin_auth_item = AuthItem.new(params[:auth_item])

    respond_to do |format|
      if @admin_auth_item.save
        format.html { redirect_to admin_auth_items_path(auth_type: @admin_auth_item.auth_type), notice: 'Auth item was successfully created.' }
        format.json { render json: @admin_auth_item, status: :created, location: @admin_auth_item }
      else
        format.html { render action: "new" }
        format.json { render json: @admin_auth_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/auth_items/1
  # PUT /admin/auth_items/1.json
  def update
    @admin_auth_item = AuthItem.find(params[:id])

    respond_to do |format|
      if @admin_auth_item.update_attributes!(params[:auth_item])
        format.html { redirect_to edit_admin_auth_item_path, notice: 'Auth item was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @admin_auth_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/auth_items/1
  # DELETE /admin/auth_items/1.json
  def destroy
    @admin_auth_item = AuthItem.find(params[:id])
    @admin_auth_item.destroy

    respond_to do |format|
      format.html { redirect_to admin_auth_items_url(auth_type: @admin_auth_item.auth_type) }
      format.json { head :no_content }
    end
  end

  def activate_admin
    admin_role = AuthItem.create_admin
    
  end

  private
  def filter_auth_type(auth_type)
    unless auth_type == AuthItem::TYPE_OPERATION
      @roles = []
      @operations = AuthItem.operations
      @tasks = AuthItem.tasks
      if auth_type == AuthItem::TYPE_ROLE
        @roles = AuthItem.roles
      end
    end   
  end
end
