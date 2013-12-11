class PostsController < ApplicationController
  before_filter :sonkwo_authenticate_account, except: [:destroy, :templates]
  before_filter :check_post_available, only: [:show, :like, :unlike, :recommend, :destroy]

  #layout "community"

  # GET /posts
  # GET /posts.json
  #def index
  #  @posts = Post.all

  #  respond_to do |format|
  #    format.html # index.html.erb
  #    format.json { render json: @posts }
  #  end
  #end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @common_post = @post
    @post = @common_post.cast
    @new_recommend = Recommend.new

    @original = @post.original.cast if @post.is_a?(Recommend)

    case params[:type].to_s.upcase
    when "RECOMMEND"
      @page_type = "recommends"
      @recommends = Recommend.recommend_posts_with_account(@post.id).paginate(page: params[:page], per_page: 10)
    when "LIKE"
      @page_type = "likers"
      @likers = Account.post_likers(@post.id).select("id, nick_name").paginate(page: params[:page], per_page: 10)
    else # COMMENT
      @page_type = "comments"
      @comments = Comment.comments_with_account(@post.id).paginate(page: params[:page], per_page: 10)
      @new_comment = @post.comments.build
    end

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

    if @post.post_type == Post::TYPE_RECOMMEND
      p = @post.cast
      @recommend.original = p.original
      @recommend.parent = @post
    else
      @recommend.original = @post
      @recommend.parent = @post
    end
    @recommend.original_author = @recommend.original.creator
    respond_to do |format|
      if @recommend.save
        format.html { redirect_to url_for(action: :show, type: 'recommend'), notice: 'Post was successfully recommended.' }
        format.json { render json: { status: "success", data: { post: @recommend } } }
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
      recommend_talk: MustacheTemplate.recommend_talk,
      recommend_subject: MustacheTemplate.recommend_subject,
      recommend_pop: MustacheTemplate.recommend_pop
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
