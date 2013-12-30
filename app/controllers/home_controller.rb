require "sonkwo/behavior/fetcher"

class HomeController < ApplicationController
  before_filter :sonkwo_authenticate_account
  before_filter :check_update_tag, only: [:index]

  def index
    @new_talk = Talk.new
    @cloud_storage_settings = CloudStorage.settings(current_account)

    params[:type] ||= "posts"
    #fetcher = Sonkwo::Behavior::Fetcher.new(current_account)
    #@behaviors = fetcher.behaviors(limit: 10, status: Post::STATUS_NORMAL)
  end

  def groups
    @groups = current_account.groups.order("created_at DESC").page(params[:page]).per(10)
  end

  def people
    @type = params[:type] || "MUTUAL"
    @type = @type.strip.upcase

    select_items = %w(id nick_name exp follower_count following_count talk_count subject_count recommend_count is_mutual avatar)
    if @type == "FANS"
      @users = current_account.fans.select(select_items.join(",")).page(params[:page]).per(10)
      #current_account.notification.reset(:followed)
    elsif @type == "STARS"
      @users = current_account.stars.select(select_items.join(",")).page(params[:page]).per(10)
    else
      @users = Account.friends(current_account).select(select_items.join(",")).order("friendship.created_at DESC").page(params[:page]).per(10)
    end
  end

  def games
    #user_game_serials = UserGameSerial.by_account(current_account.id).includes(:game)
  end

  def posts
    params[:type] ||= "posts"
    if params[:type] == "posts"
      stream = Stream::Account.new(current_account, nil, min_id: params[:end_id].to_i, order: "created_at DESC")
      @stream_posts = stream.stream_posts.limit(9)
    elsif params[:type] == "groups"
      stream = Stream::Group.new(current_account, nil, min_id: params[:end_id].to_i, order: "created_at DESC")
      @stream_posts = stream.stream_posts.limit(9)
    else
      @stream_posts = []
    end

    respond_to do |format|
      format.html
      format.json
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
    @recommends = Recommend.account_recommended(current_account.id).page(params[:page]).per(10)
    Post.downcast(@recommends, "original")
    current_account.notification.reset(:recommended)

    respond_to do |format|
      format.html
    end
  end

  def add_tag
    @tag = Tag.find(params[:tag_id])
    if current_account.tags.exists?(@tag) || current_account.tags << @tag
      render json: { status: "success", data: { id: @tag.id } }
    else
      render json: { status: "error", message: I18n.t("common.unknow_error") }
    end
  end

  def remove_tag
    @tag = Tag.find(params[:tag_id])
    if !current_account.tags.exists?(@tag) || current_account.tags.delete(@tag)
      render json: { status: "success", data: { id: @tag.id } }
    else
      render json: { status: "error", message: I18n.t("common.unknow_error") }
    end
  end

  private
  def check_update_tag
    redirect_to controller: :informations if current_account.update_tag.to_i < Account::UPDATE_TAG_FINISH
  end
end
