require 'sonkwo/behavior/fetcher'

class GroupsController < ApplicationController
  before_filter :sonkwo_authenticate_account, except: [:index, :show, :posts, :members]

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
      format.html # index.html.slim
      format.json { render json: @groups }
    end
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
    @group = Group.find(params[:id])
    @new_talk = Talk.new
    @new_talk.group = @group
    @cloud_storage_settings = CloudStorage.settings(current_account) if current_account
    @tags = @group.tags
    @newcomers = @group.accounts.order("groups_accounts.created_at DESC").limit(21)
    @is_added = current_account ? @group.accounts.include?(current_account) : false

    respond_to do |format|
      format.html # show.html.slim
      format.json { render json: @group }
    end
  end

  # GET /groups/new
  # GET /groups/new.json
  def new
    return unless check_access?(auth_item: "oper_groups_create")
    @group = Group.new

    respond_to do |format|
      format.html do
        qiniu_prepare(Settings.cloud_storage.group_bucket)
      end
      format.json { render json: @group }
    end
  end

  # GET /groups/1/edit
  def edit
    @group = Group.find(params[:id])
    return unless check_access?(auth_item: "oper_groups_update", group: @group)
    qiniu_prepare(Settings.cloud_storage.group_bucket)
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
        format.html do
          qiniu_prepare(Settings.cloud_storage.group_bucket)
          render action: "new"
        end
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

  def members
    @group = Group.find(params[:id])
    @members = @group.accounts.not_in([@group.creator_id]).page(params[:page]).per(12)
    @show_creator = true if !params[:page] || params[:page].to_i <= 0
  end

  def posts
    @group = Group.find(params[:id])
    stream = Stream::Group.new(current_account, @group, min_id: params[:end_id].to_i, order: "created_at DESC")
    @stream_posts = stream.stream_posts.limit(9)
    respond_to do |format|
      format.html
      format.json
    end
  end

  def add_user
    @group = Group.find(params[:id])
    @group.accounts << current_account if current_account && !@group.accounts.include?(current_account)
    respond_to do |format|
      format.html { redirect_to :back }
      format.json { render json: { status: "success", data: { account_id: current_account.id, group_id: @group.id} } }
    end
  end

  def remove_user
    @group = Group.find(params[:id])
    if @group.creator.id == current_account.id
      respond_to do |format|
        format.html { redirect_to :back, error: I18n.t("account.quit_failed_as_a_creator") }
        format.json { render json: { status: "error", message: I18n.t("account.quit_failed_as_a_creator") } }
      end
    else
      @group.accounts.destroy current_account if current_account && current_account.id != @group.creator.id

      respond_to do |format|
        format.html { redirect_to :back }
        format.json { render json: { status: "success", data: { account_id: current_account.id, group_id: @group.id } } }
      end
    end
  end

  def add_tags
    @group = Group.find(params[:id])
  end
end
