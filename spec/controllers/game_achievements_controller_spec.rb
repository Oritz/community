require 'spec_helper'

describe GameAchievementsController do
  let(:game) { create(:all_game) }

  describe "GET index" do
    it "should show all achievements with valid game" do
      game_achievements = create_list(:game_achievement, 25, game: game)

      get :index, game_id: game.id
      expect(assigns(:game_achievements)).to eq(game_achievements)
      expect(assigns(:game)).to eq(game)
    end
  end

  describe "GET show" do
    let(:game_achievement) { create(:game_achievement, game: game) }

    it "should show details of an achievement" do
      get :show, game_id: game.id, id: game_achievement.id
      expect(assigns(:game_achievement)).to eq(game_achievement)
    end
  end
end
