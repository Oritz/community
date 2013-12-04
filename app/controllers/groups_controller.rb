class GroupsController < ApplicationController
  #before_filter :sonkwo_authenticate_account, except: [:index, :show]

  # GET /groups
  # GET /groups.json
  def index
    # TODO: rewrite the function without any "joins"
    if current_account
      @groups = Group.joins("LEFT JOIN groups_accounts ON group_id=id AND account_id=#{current_account.id}")
                     .select("groups.*, account_id")
                     .order("member_count DESC")
                     .limit(10)
    else
      @groups = Group.sort_by_hot(10)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @groups }
    end
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
    # TODO: rewrite the function without andy "select"
    @group = Group.find(params[:id])
    @tags = @group.tags
    #@newcomers = @group.accounts.select("id, nick_name, avatar").order("groups_accounts.created_at DESC").limit(6)
    #@subjects = Subject.sort_by_time_in_group(@group.id).paginate(page: params[:page], per_page: 10)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @group }
    end
  end

  # GET /groups/new
  # GET /groups/new.json
  def new
    return unless check_access?(auth_item: "oper_groups_create")
    @group = Group.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @group }
    end
  end

  # GET /groups/1/edit
  def edit
    @group = Group.find(params[:id])
    return unless check_access?(auth_item: "oper_groups_update", group: @group)
  end

  # POST /groups
  # POST /groups.json
  def create
    return unless check_access?
    @group = Group.new(params[:group])
    @group.creator = current_account

    respond_to do |format|
      if @group.save
        format.html { redirect_to @group, notice: 'Group was successfully created.' }
        format.json { render json: @group, status: :created, location: @group }
      else
        format.html { render action: "new" }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /groups/1
  # PUT /groups/1.json
  def update
    @group = Group.find(params[:id])
    return unless check_access?(group: @group)

    respond_to do |format|
      if @group.update_attributes(params[:group])
        format.html { redirect_to @group, notice: 'Group was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group = Group.find(params[:id])
    return unless check_access?(group: @group)
    @group.destroy

    respond_to do |format|
      format.html { redirect_to groups_url }
      format.json { head :no_content }
    end
  end

  def add_user
    @group = Group.find(params[:id])
    @group.accounts << current_account if current_account && !@group.accounts.include?(current_account)
    respond_to do |format|
      format.html { redirect_to :back }
      format.json { head :no_content }
    end
  end

  def remove_user
    @group = Group.find(params[:id])
    @group.accounts.delete current_account if current_account && current_account.id != @group.creator.id

    respond_to do |format|
      format.html { redirect_to :back }
      format.json { head :no_content }
    end
  end

  def add_tags
    @group = Group.find(params[:id])
  end
end
