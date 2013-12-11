require 'spec_helper'

describe TalksController do
  describe "GET show" do
    it "should render a talk with comments"
  end

  describe "POST create" do
    context "with json" do
      login_account
      let(:account) { create(:account) }

      it "should create a talk without image" do
        params = {format: :json, talk: {content: "content"}}
        post :create, params

        talk = Talk.first
        body = JSON.parse(response.body)
        expect(body["status"]).to eq "success"
        expect(body["data"]["id"]).to eq talk.id
      end

      it "should create a talk with image specified by cloud_storage_id" do
        cloud_storage = create(:cloud_storage)
        params = {format: :json, talk: {content: "content", cloud_storage_id: cloud_storage.id}}
        post :create, params

        talk = Talk.first
        body = JSON.parse(response.body)
        expect(body["status"]).to eq "success"
        expect(body["data"]["id"]).to eq talk.id
        expect(body["data"]["image_url"]).to eq cloud_storage.url
      end
    end
  end
end
