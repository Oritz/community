class CommentsController < ApplicationController
  before_filter :sonkwo_authenticate_account
  layout "home"

  # GET /comments/index
  # GET /comments/index.json
  def index
    @post = Post.find(params[:post_id])
    @comments = Comment.comments_with_account(@post.id).paginate(page: params[:page], per_page: 10)

    respond_to do |format|
      format.html
      format.json do
=begin
        data = []
        @comments.each do |comment|
          item_data = {}
          item_data[:comment] = comment.comment
          item_data[:created_at] = comment.created_at
          item_data[:creator] = {}
          item_data[:creator][:id] = comment.creator.id
          item_data[:creator][:nick_name] = comment.creator.nick_name
          item_data[:creator][:avatar] = comment.creator.avatar
          if comment.original_author
            item_data[:original_author] = {}
            item_data[:original_author][:id] = comment.original_author.id
            item_data[:original_author][:nick_name] = comment.original_author.nick_name
          end
          data << item_data
        end
=end
        # TODO: Render data(not html)
        data = ""
        @comments.each do |comment|
          html = render_to_string(partial: "posts/comment.html", locals: {comment: comment})
          data += html
        end
        render json: { status: "success", data: data }
      end
    end
  end

  # GET /comments/new
  # GET /comments/new.json
  def new
    @post = Post.find(params[:post_id])
    @comment = Comment.new

    respond_to do |format|
      format.html # new.html.slim
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
        format.json { render json: @comment, status: :created, location: @comment }
      else
        format.html { render action: "show", controller: "posts" }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
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
