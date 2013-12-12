class CommentsController < ApplicationController
  before_filter :sonkwo_authenticate_account

  # GET /comments/index
  # GET /comments/index.json
  def index
    @post = Post.find(params[:post_id])
    @comments = Comment.comments_of_a_post(@post).includes(:creator, :original_author).order("created_at DESC").paginate(page: params[:page], per_page: 10)

    respond_to do |format|
      format.html
      format.json { render_for_api :comment_info, json: @comments, root: "data", meta: { status: "success" } }
    end
  end

  # GET /comments/new
  # GET /comments/new.json
  def new
    @post = Post.find(params[:post_id])
    @comment = Comment.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @comment }
    end
  end

  # POST /comments
  # POST /comments.json
  def create
    @comment = Comment.new(params[:comment])
    @comment.creator = current_account
    post = Post.find(params[:post_id])
    @comment.post = post
    @comment.post_author = post.creator

    if params[:original_id]
      original_comment = Comment.find(params[:original_id])
      @comment.original = original_comment
      @comment.original_author = original_comment.creator
    end

    respond_to do |format|
      if @comment.save
        format.html { redirect_to post, notice: 'Comment was successfully created.'}
        format.json { render_for_api :comment_info, json: @comment, root: "data", meta: { status: "success" } }
      else
        format.html { render action: "show", controller: "posts" }
        format.json { render json: { status: "fail", data: @comment.errors } }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment = Comment.find(params[:id])
    return unless check_access?(comment: @comment)
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to comments_url }
      format.json { head :no_content }
    end
  end

  def in
    @comments = Comment.account_in(current_account.id).paginate(page: params[:page], per_page: 10)
    @is_in = true

    current_account.notification.reset(:commented)

    Post.downcast(@comments, "post")
    respond_to do |format|
      format.html { render :comments_box }
    end
  end

  def out
    @comments = Comment.account_out(current_account.id).paginate(page: params[:page], per_page: 10)
    @is_in = false

    Post.downcast(@comments, "post")
    respond_to do |format|
      format.html { render :comments_box }
    end
  end
end
