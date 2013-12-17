class SubjectsController < ApplicationController
  before_filter :sonkwo_authenticate_account, only: [:create, :new, :update]

  def show
    # Show the content of a post and comments
    @subject = Subject.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @subject }
    end
  end

  def new
    @post = current_account.pending_subject
    @subject = @post.detail
    @subject.post = @post
    @cloud_storage_settings = CloudStorage.settings(current_account)
    @new_post_image = PostImage.new
    @post_images = @subject.post.post_images.includes(:cloud_storage)

    if params[:group_id]
      @group = Group.find(params[:group_id])
      @subject.group = @group
    end

    respond_to do |format|
      format.html
      format.json { render json: @group }
    end
  end

  def edit
    @subject = Subject.find(params[:id])
    return unless check_access?(auth_item: "oper_subjects_update", subject: @subject)
  end

  def update
    @subject = Subject.find(params[:id])
    if params[:group_id]
      @group = Group.find(params[:group_id])
      @subject.group = @group
    end

    if params[:is_post].to_i == 1
      if @subject.status != Post::STATUS_DELETED
        @subject.status = Post::STATUS_NORMAL
      else
        respond_to do |format|
          format.html
          format.json { render json: { status: "error", message: I18n.t("post.is_deleted") }}
        end
        return
      end
    end

    respond_to do |format|
      if @subject.update_attributes(params[:subject])
        format.html { redirect_to @subject.post, notice: 'Subject was successfully created.' }
        format.json { render json: { status: "success", data: { id: @subject.id, post: { id: @subject.post.id } } } }
      else
        format.html { redirect_to :new }
        format.json { render json: { status: "fail", data: @subject.errors } }
      end
    end
  end
end
