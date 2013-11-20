class GameAchievementsController < ApplicationController
  def index
    @game = AllGame.find(params[:game_id])
    @game_achievements = @game.game_achievements

    respond_to do |format|
      format.html
    end
  end

  def show
    @game = AllGame.find(params[:game_id])
    @game_achievement = GameAchievement.find(params[:id])
  end
end
