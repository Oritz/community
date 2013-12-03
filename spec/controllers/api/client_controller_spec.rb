require 'spec_helper'

describe Api::ClientController do
  describe "POST post_err_msg" do
    login_account

    it "should return success" do
      err_msg = "test"
      post :post_err_msg, err_msg: err_msg, format: :json

      ret = { status: "success", data: {} }
      expect(response.status).to eq 200
      expect(response.body).to eq ret.to_json
    end
  end

  describe "GET get_latest_client_version" do
    it "should return success" do
      client_update = create(:client_update, major_ver: 1)
      get :get_latest_client_version

      ret = {
        status: "success",
        data: {
          major_ver: client_update.major_ver,
          minor_ver: client_update.minor_ver,
          tiny_ver: client_update.tiny_ver
        }
      }

      expect(response.body).to eq ret.to_json
    end

    it "should return fail" do
      get :get_latest_client_version

      expect(JSON.parse(response.body)["status"]).to eq "fail"
    end
  end
end
