require 'sonkwo/behavior/fetcher'

class UsersController < ApplicationController
  before_filter :sonkwo_authenticate_account, only: [:follow, :unfollow]

  def show
    @target = Account.find(params[:id])
    @relation = Friendship::IRRESPECTIVE
    @relation = current_account.get_relation(@target) if current_account
    @recent_game_achievements = @target.recent_game_achievements(3)
    @games = AllGame.belong_to_account(@target).available;

    stream = Stream::Account.new(current_account, @target, min_id: params[:end_id].to_i, order: "created_at DESC")
    @stream_posts = stream.stream_posts.limit(9)

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
                            .page(params[:page]).per(10)

    respond_to do |format|
      format.html
      format.json { render json: @target }
    end
  end

  def posts
    @target = Account.find(params[:id])
    stream = Stream::Account.new(current_account, @target, min_id: params[:end_id].to_i, order: "created_at DESC")
    @stream_posts = stream.stream_posts.limit(9)

    respond_to do |format|
      format.html
      format.json
    end
  end

  def people
    @target = Account.find(params[:id])
    params[:type] ||= "friends"
    case params[:type].downcase
    when "stars"
      show_type = "stars"
    when "fans"
      show_type = "fans"
    else
      show_type = "friends"
    end

    relation = Relation::Account.new(current_account, @target, show_type, order: "created_at DESC", paginate: {per: 9, page: params[:page]})
    @users = relation.relation_accounts
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
          format.json { render json: { status: "success", data: { is_mutual: @friendship.is_mutual } } }
        end
      else
        respond_to do |format|
          format.html { redirect_to :back, notice: "Follow failed." }
          format.json { render json: { status: "fail", data: @friendship.errors } }
        end
      end
    end
  end

  def unfollow
    @friendship = Friendship.find(params[:target_id], current_account.id)
    if @friendship.destroy
      respond_to do |format|
        format.html { redirect_to :back, notice: "Unfollow successfully." }
        format.json { render json: { status: "success", data: { is_mutual: @friendship.is_mutual } } }
      end
    else
      respond_to do |format|
        format.html { redirect_to :back, notice: "Unfollow failed." }
        format.json { render json: { status: "fail", data: @friendship.errors } }
      end
    end
  end

  def games
    @target = Account.find(params[:id])
    # @games = @target.other_games.where(status: AllGame::STATUS_NORMAL)
    # @games = @games | @target.steam_user.games if @target.steam_user
    @games = AllGame.belong_to_account(@target).where("all_games.status=?", AllGame::STATUS_NORMAL)

    respond_to do |format|
      format.html
      format.json
    end
  end

  def game
    @game = AllGame.find(params[:game_id])
    @account = Account.find(params[:id])
    respond_to do |format|
      format.html do
        @statistic = @account.game_statistic(@game, false)
        not_found unless @statistic
        @game_achievements_count = @game.game_achievements.count
        @game_achievements = @account.game_achievements(@game)
      end
      format.json do
        @statistic = @account.game_statistic(@game)
        @ranklists = @game.ranklists.order("reputation DESC").limit(5).fill_account
        if @statistic
          render
        else
          render json: { status: "error", message: I18n.t("account.not_have_game") }
        end
      end
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
