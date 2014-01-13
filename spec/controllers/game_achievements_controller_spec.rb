require 'spec_helper'

describe GameAchievementsController do
  let(:steam_game) { create(:steam_game) }
  let(:game) { steam_game.game }

  describe "GET index" do
    it "should show all achievements with valid game" do
      steam_game_achievements = create_list(:steam_game_achievement, 25, steam_game: steam_game)
      game_achievements = steam_game_achievements.map(&:game_achievement)

      get :index, game_id: game.id
      expect(assigns(:game_achievements)).to eq(game_achievements)
      expect(assigns(:game)).to eq(game)
    end
  end

  describe "GET show" do
    let(:game_achievement) { create(:steam_game_achievement, steam_game: steam_game).game_achievement }

    it "should show details of an achievement" do
      get :show, game_id: game.id, id: game_achievement.id
      expect(assigns(:game_achievement)).to eq(game_achievement)
    end
  end
end
