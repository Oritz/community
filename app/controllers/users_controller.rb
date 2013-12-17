require 'sonkwo/behavior/fetcher'

class UsersController < ApplicationController
  before_filter :sonkwo_authenticate_account, only: [:follow, :unfollow]

  def show
    @target = Account.find(params[:id])
    @new_talk = Talk.new
    @cloud_storage_settings = CloudStorage.settings(@target)

    respond_to do |format|
      format.html
      format.json { render json: @target }
    end
  end

  def groups
    @target = Account.find(params[:id])
    @type = "GROUPS"

    @groups = @target.groups.joins("LEFT JOIN groups_accounts AS g ON g.group_id=id AND g.account_id=#{current_account ? current_account.id : 0}")
                            .select("groups.*, g.account_id AS gaid")
                            .order("created_at DESC")
                            .paginate(page: params[:page], per_page: 10)

    respond_to do |format|
      format.html
      format.json { render json: @target }
    end
  end

  def posts
    @target = Account.find(params[:id])
    fetcher = Sonkwo::Behavior::Fetcher.new(current_account, target: @target)
    if params[:end_id]
      @posts = fetcher.behaviors(limit: 2, max_id: params[:end_id], status: Post::STATUS_NORMAL, order: "created_at DESC")
    else
      @posts = fetcher.behaviors(limit: 2, status: Post::STATUS_NORMAL, order: "created_at DESC")
    end

    respond_to do |format|
      format.html
      format.json { render_for_api :post_info, json: @posts, root: "data", meta: {status: "success"} }
    end
  end

  def people
    @target = Account.find(params[:id])
    show_fans = params[:type] ? (params[:type].downcase == "fans") : false

    if show_fans
      @type = "FANS"
      @users = @target.people_relation_with_visitor(visitor: current_account, select: "id, nick_name, avatar", type: Friendship::FOLLOWER, page: params[:page], per_page: 10)
    else
      @type = "STARS"
      @users = @target.people_relation_with_visitor(visitor: current_account, select: "id, nick_name, avatar", type: Friendship::FOLLOWING, page: params[:page], per_page: 10)
    end
  end

  def follow
    @friendship = Friendship.new
    @target = Account.find(params[:target_id])
    if current_account != @target
      @friendship.account = @target
      @friendship.follower = current_account
      if @friendship.save
        respond_to do |format|
          format.html { redirect_to :back, notice: "Follow successfully." }
          format.json { render json: @friendship }
        end
      else
        respond_to do |format|
          format.html { redirect_to :back, notice: "Follow failed." }
          format.json { render json: @friendship }
        end
      end
    end
  end

  def unfollow
    @friendship = Friendship.find(params[:target_id], current_account.id)
    if @friendship.destroy
      respond_to do |format|
        format.html { redirect_to :back, notice: "Unfollow successfully." }
        format.json { render json: @friendship }
      end
    else
      respond_to do |format|
        format.html { redirect_to :back, notice: "Unfollow failed." }
        format.json { render json: @friendship }
      end
    end
  end

  def games
    @target = Account.find(params[:id])
    #@games = @target.other_games.where(status: AllGame::STATUS_NORMAL)
    #@games = @games | @target.steam_user.games if @target.steam_user
    @games = AllGame.belong_to_account(@target).where("all_games.status=?", AllGame::STATUS_NORMAL)

    respond_to do |format|
      format.html
      format.json { render_for_api :game_basic_info, json: @games, root: "data", meta: {status: "success"} }
    end
  end

  def check_name
    account = Account.new(params[:account])
    if !account.valid? && account.errors[:nick_name] == []
      render json: { status: "success", data: nil }
    else
      render json: { status: "fail", data: account.errors[:nick_name] }
    end
  end
end
