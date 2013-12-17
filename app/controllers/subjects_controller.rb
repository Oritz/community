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

  def create
    
  end

  def edit
    @subject = Subject.find(params[:id])
    return unless check_access?(auth_item: "oper_subjects_update", subject: @subject)
  end

  def update
    @subject = current_account.pending_subject
    if params[:group_id]
      @group = Group.find(params[:group_id])
      @subject.group = @group
    end
    
    @subject.status = Post::STATUS_NORMAL if params[:status] == Post::STATUS_NORMAL

    respond_to do |format|
      if @subject.
        format.html { redirect_to @subject.post, notice: 'Subject was successfully created.' }
        format.json { render json: @subject, status: :created, location: @subject }
      else
        format.html { redirect_to :new } #TODO: 
        format.json { raise "TODO:" } #TODO:
      end
    end
  end
end