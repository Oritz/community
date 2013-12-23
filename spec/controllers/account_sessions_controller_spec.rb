require 'spec_helper'

describe AccountSessionsController do
  let(:password) { "12345678" }
  let(:account) { create(:account, password: password) }

  describe "POST create" do
    it "should create a new session" do
      pending "test cookies"
      expect(subject.current_account).not_to be_nil
    end

    it "should create a new session with json" do
      @request.env["devise.mapping"] = Devise.mappings[:account]
      params = {"format" => "json", "account" => {"email" => account.email, "password" => password}}
      post :create, params

      response_data = {
        status: 'success',
        data: {
          account_id: account.id,
          nick_name: account.nick_name,
          token: controller.send("form_authenticity_token"),
          avatar: account.avatar
        }
      }

      expect(response.status).to eq 200
      expect(response.body).to eq response_data.to_json
    end
  end

  describe "DELETE destroy" do
    it "deletes a session" do
      pending "TO BE DONE"
    end
  end
end
