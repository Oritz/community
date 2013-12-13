require 'spec_helper'

describe PostImagesController do
  describe "POST create" do
    login_account
    let(:cloud_storage) { create(:cloud_storage, account: controller.current_account) }
    let(:subject) { create(:subject, creator: controller.current_account) }

    it "should create a new post_image" do
      params = {format: :json, post_image: {comment: "comment"}, subject_id: subject.id, cloud_storage_id: cloud_storage.id}
      post :create, params

      ret = { status: "success", data: { url: cloud_storage.url } }
      expect(response.body).to eq ret.to_json
    end
  end
end
