class HomeController < ApplicationController
  before_filter :sonkwo_authenticate_account
  #layout "home"

  def index
    @new_talk = Talk.new
    @new_subject = Subject.new

    params[:type] ||= "posts"
    #fetcher = Sonkwo::Behavior::Fetcher.new(current_account)
    #@behaviors = fetcher.behaviors(limit: 10, status: Post::STATUS_NORMAL)
  end

  def groups
    @groups = current_account.groups.order("created_at DESC").paginate(page: params[:page], per_page: 10)
  end

  def people
    show_fans = params[:type] ? (params[:type].downcase == "fans") : false

    if show_fans
      @type = "FANS"
      @users = current_account.people_relation_with_visitor(select: "id, nick_name, avatar", type: Friendship::FOLLOWER, page: params[:page], per_page: 10)
      current_account.notification.reset(:followed)
    else
      @type = "STARS"
      @users = current_account.people_relation_with_visitor(select: "id, nick_name, avatar", type: Friendship::FOLLOWING, page: params[:page], per_page: 10)
    end
  end

  def games
    user_game_serials = UserGameSerial.by_account(current_account.id).includes(:game)
  end

  def posts
    params[:type] ||= "posts"
    if params[:type] == "posts"
      fetcher = Sonkwo::Behavior::Fetcher.new(current_account)
      if params[:end_id]
        @posts = fetcher.behaviors(limit: 2, max_id: params[:end_id], status: Post::STATUS_NORMAL, order: "created_at DESC")
      else
        @posts = fetcher.behaviors(limit: 2, status: Post::STATUS_NORMAL, order: "created_at DESC")
      end
      @posts = Post.downcast(@posts)
    elsif params[:type] == "groups"
      @posts = Subject.subjects_in_groups_added(current_account.id, 2)
      @posts = @posts.where("subjects.id < ?", params[:end_id]) if params[:end_id]
    else
      @posts = []
    end

    respond_to do |format|
      format.html
      format.json { render_for_api :post_info, json: @posts, root: "data", meta: {status: "success"} }
    end
  end

  def notification
    @notification = current_account.notification

    respond_to do |format|
      format.html
      format.json { render_for_api :notify, json: @notification, root: "data", meta: {status: "success"} }
    end
  end

  def recommended
    @recommends = Recommend.account_recommended(current_account.id).paginate(page: params[:page], per_page: 10)
    Post.downcast(@recommends, "original")
    current_account.notification.reset(:recommended)

    respond_to do |format|
      format.html
    end
  end
end
