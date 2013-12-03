require 'spec_helper'

describe Api::UserController do
  login_account

  describe "POST post_action" do
    it "should return success" do
      file = "#{UserAction::ACTION_CLIENT_LOGIN},object_name,#{Time.now.to_i}\r\n#{UserAction::ACTION_CLIENT_LOGOUT},object_name,#{Time.now.to_i}"
      post :post_action, file: file, format: :json

      ret = {status: "success", data: {}}
      expect(response.body).to eq ret.to_json
    end

    it "should return fail" do
      post :post_action, file: nil, format: :json
      expect(JSON.parse(response.body)["status"]).to eq "fail"
    end
  end

  describe "POST update_env" do
    it "should return success" do
      data = {
        machine_id: "machine_id",
        os: "xp",
        cpu: "cpu",
        ram: 4,
        hdd: 5,
        graphics_card: "card",
        screen_w: 100,
        screen_h: 200,
        dx_ver_major: 1,
        dx_ver_minor: 2,
        dx_ver_tiny: 3,
        dot_net_ver_major: 1,
        dot_net_ver_minor: 2,
        dot_net_ver_tiny: 3,
        vc_rt_ver_major: 1,
        vc_rt_ver_minor: 2,
        mac_address: "mac"
      }

      post :update_env, data: data.to_json, format: :json
      expect(JSON.parse(response.body)["status"]).to eq "success"
    end
  end

  describe "POST update_profile"
  describe "GET get_play_time" do
    let(:game) { create(:game) }
    let(:account) { create(:account) }

    it "should return success" do
      now = Time.now
      100.times do |i|
        Timecop.freeze(now + i * 1000)
        create(:user_game_play_history, game: game, account: account, start_time: Time.now.to_i, exit_time: (Time.now+500).to_i)
        Timecop.return
      end

      get :get_play_time, game_id: game.id, format: :json

      expect(JSON.parse(response.body)["status"]).to eq "success"
    end
  end
end
