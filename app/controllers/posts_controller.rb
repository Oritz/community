class PostsController < ApplicationController
  before_filter :sonkwo_authenticate_account, except: [:destroy, :templates]
  before_filter :check_post_available, only: [:show, :like, :unlike, :recommend, :destroy]

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

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.find(params[:id])
    not_found if @post.detail_type != Subject.to_s
    not_found if @post.status != Post::STATUS_NORMAL

    @original = @post.original.cast if @post.is_a?(Recommend)

    @comments = Comment.of_a_post(@post).paginate(page: params[:page], per_page: 10)
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
    @recommend = Recommend.new(params[:recommend])
    @recommend.creator = current_account

    if @post.detail_type == Recommend.to_s
      @recommend.original = @post.detail.original
      @recommend.parent = @post
    else
      @recommend.original = @post
      @recommend.parent = @post
    end
    @recommend.original_author = @recommend.original.creator
    @recommend.post.detail = @recommend
    respond_to do |format|
      if @recommend.save
        format.html { redirect_to url_for(action: :show, type: 'recommend'), notice: 'Post was successfully recommended.' }
        format.json { render_for_api :post_info, json: @recommend.post, root: "data", meta: { status: "success" } }
      else
        format.html { redirect_to :back, alert: 'Recommend failed.' }
        format.json { render json: { status: "fail", data: @recommend.errors.full_messages } }
      end
    end
  end

  def templates
    templates = {
      talk: MustacheTemplate.talk,
      subject: MustacheTemplate.subject,
      recommend: MustacheTemplate.recommend,
      recommend_pop: MustacheTemplate.recommend_pop,
      comment: MustacheTemplate.comment
    }

    render json: { status: 'success', data: templates }
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
