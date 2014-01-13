class PostsController < ApplicationController
  before_filter :sonkwo_authenticate_account, except: [:show]
  before_filter :check_post_available, only: [:show, :like, :unlike, :recommend, :destroy, :edit, :update]

  #layout "community"

  # GET /posts
  # GET /posts.json
  #def index
  #  @posts = Post.all

  #  respond_to do |format|
  #    format.html # index.html.slim
  #    format.json { render json: @posts }
  #  end
  #end

  def new
    # Only create a subject
    @post = current_account.pending_subject!
    qiniu_prepare(Settings.cloud_storage.post_bucket)
    @new_post_image = PostImage.new
    @post_images = @post.post_images.includes(:cloud_storage)

    if params[:group_id]
      @group = Group.find(params[:group_id])
      @post.group = @group
    end

    respond_to do |format|
      format.html
      format.json { render json: @group }
    end
  end

  def create
    # Only create a Talk
    @post = Post.new(params[:post])
    @post.post_type = Post::TYPE_TALK
    @post.creator = current_account
    if(params[:group_id])
      @group = Group.find(params[:group_id])
      @post.group = @group
    end

    respond_to do |format|
      if @post.save
        format.html
        format.json
      else
        format.html
        format.json { render json: { status: "fail", data: @post.errors } }
      end
    end
  end

  def edit
    # Only for subjects
    not_found unless @post.is_subject?

    @post = current_account.pending_subject!
    qiniu_prepare(Settings.cloud_storage.post_bucket)
    @new_post_image = PostImage.new
    @post_images = @post.post_images.includes(:cloud_storage)

    if params[:group_id]
      @group = Group.find(params[:group_id])
      @post.group = @group
    end

    respond_to do |format|
      format.html
      format.json { render json: @group }
    end
  end

  def update
    not_found unless @post.is_subject?

    if params[:group_id]
      @group = Group.find(params[:group_id])
      @post.group = @group
    end

    @post.status = Post::STATUS_NORMAL if params[:is_post].to_i == 1

    respond_to do |format|
      if @post.update_attributes(params[:post])
        format.html do
          if @post.is_normal?
            redirect_to @post, notice: I18n.t("post.subject_created_successfully")
          else
            render action: :edit
          end
        end
        format.json { render json: { status: "success", data: { id: @post.id } } }
      else
        format.html do
          qiniu_prepare(Settings.cloud_storage.post_bucket)
          @new_post_image = PostImage.new
          @post_images = @post.post_images.includes(:cloud_storage)
          render action: :edit
        end
        format.json { render json: { status: "fail", data: @post.errors } }
      end
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @comments = Comment.of_a_post(@post).page(params[:page]).per(10)
    @new_comment = @post.comments.build

    respond_to do |format|
      format.html
      format.json { render json: @post }
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    return unless check_access?(post: @post)
    @post.status = Post::STATUS_DELETED
    @post.save!

    respond_to do |format|
      format.html { redirect_to home_index_path }
      format.json { render json: {status: "success", data: nil} }
    end
  end

  def like
    if current_account.like_posts.include?(@post)
      respond_to do |format|
        format.html { redirect_to :back }
        format.json { render json: { status: "fail", data: {message: I18n.t("post.is_liked")} } }
      end
    else
      current_account.like_posts << @post
      respond_to do |format|
        format.html { redirect_to :back }
        format.json { render json: { status: "success", data: {like_count: @post.like_count} } }
      end
    end
  end

  def unlike
    if current_account.like_posts.include?(@post)
      current_account.like_posts.delete @post
      respond_to do |format|
        format.html { redirect_to :back }
        format.json { render json: { status: "success", data: {like_count: @post.like_count} } }
      end
    else
      respond_to do |format|
        format.html { redirect_to :back }
        format.json { render json: { status: "fail", data: {message: I18n.t("post.is_unliked")} } }
      end
    end
  end

  def recommend
    result = current_account.recommend(@post, params[:recommendation])
    @recommend = result[1]

    respond_to do |format|
      if result[0]
        format.html { redirect_to url_for(action: :show, type: 'recommend'), notice: 'Post was successfully recommended.' }
        format.json
      else
        format.html { redirect_to :back, alert: 'Recommend failed.' }
        format.json { render json: { status: "fail", data: @recommend.errors.full_messages } }
      end
    end
  end

  protected
  def check_post_available
    @post = Post.find(params[:id])
    if @post.status == Post::STATUS_DELETED
      respond_to do |format|
        format.html { redirect_to :back, flash: { error: I18n.t("messages.posts.deleted") } }
        format.json { render json: {status: "error", message: I18n.t("messages.posts.deleted")} }
      end
      return false
    end
    true
  end
end
