require 'spec_helper'

describe PostImagesController do
  describe "POST create" do
    login_account
    let(:cloud_storage) { create(:cloud_storage, account: controller.current_account) }
    let(:subject) { create(:subject, creator: controller.current_account) }

    it "should create a new post_image" do
      params = {format: :json, post_image: {comment: "comment"}, post_id: subject.id, cloud_storage_id: cloud_storage.id}
      post :create, params

      post_image = PostImage.first
      ret = { status: "success", data: { id: post_image.id, cloud_storage_id: cloud_storage.id, url: cloud_storage.url } }
      expect(response.body).to eq ret.to_json
    end
  end

  describe "DELETE destroy" do
    login_account
    let(:subject) { create(:subject, creator: controller.current_account) }
    let(:post_image) { create(:post_image, post: subject) }

    it "should delete a post_image" do
      params = {format: :json, post_id: subject.id, id: post_image.id}
      delete :destroy, params

      post_image_count = PostImage.count
      ret = { status: "success", data: { id: post_image.id } }
      expect(response.body).to eq ret.to_json
      expect(post_image_count).to eq 0
    end
  end
end
