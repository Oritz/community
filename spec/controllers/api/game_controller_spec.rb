require 'spec_helper'

describe Api::GameController do
  let(:serial_type) { create(:serial_type, type_name: "TYPE_OFFLINE_PRODUCT_KEY") }

  describe "GET list_my_games" do
    login_account
    it "should return success" do
      order_game = create(:order_game, account: controller.current_account, drupal_account_id: 1)
      user_game_serial = create(:user_game_serial, account: controller.current_account, serialtype: serial_type)

      get :list_my_games
      expect(JSON.parse(response.body)["status"]).to eq "success"
    end
  end

  describe "GET list_my_game_ids" do
    login_account
    it "should return success" do
      order_game = create(:order_game, account: controller.current_account, drupal_account_id: 1)
      user_game_serial = create(:user_game_serial, account: controller.current_account, serialtype: serial_type)

      get :list_my_game_ids
      expect(JSON.parse(response.body)["status"]).to eq "success"
    end
  end

  describe "GET get_game_info" do
    login_account
    let(:game) { create(:game) }

    it "should return success via game id" do
      get :get_game_info, game_id: game.id
      body = response.body
      expect(JSON.parse(body)["status"]).to eq "success"
      expect(JSON.parse(body)["data"]["game"]["gameName"]).to eq game.title
    end

    it "should return success via game title" do
      get :get_game_info, game_name: game.alias_name
      body = response.body
      expect(JSON.parse(body)["status"]).to eq "success"
      expect(JSON.parse(body)["data"]["game"]["gameName"]).to eq game.title
    end
  end

  describe "GET get_game_dlcs" do
    login_account
    let(:game_dlc) { create(:game_dlc) }

    it "should return success" do
      get :get_game_dlcs, game_id: game_dlc.parent.id

      data = JSON.parse(response.body)
      expect(data["status"]).to eq "success"
      expect(data["data"]["base_game_id"]).to eq game_dlc.parent.id
    end
  end

  describe "GET request_game_shell"
  describe "GET request_game_ini"
  describe "GET get_game_seed"
  describe "GET get_serial_number"
  describe "POST register_serial_number"
  describe "GET get_game_news"
end
