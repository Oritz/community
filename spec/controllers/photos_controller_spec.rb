require 'spec_helper'

describe PhotosController do
  describe "POST screenshot" do
    login_account

    it "should create a new photo via json" do
      album = Album.screenshot_of_account(controller.current_account).first
      params = {format: :json, photo: {description: "description", url: "http://bucket_name.u.qiniudn.com/key"}}
      post :screenshot, params

      photo = Photo.where(album_id: album.id).first
      ret = { status: "success", data: { id: photo.id } }
      expect(response.body).to eq ret.to_json
    end

    it "should failed while create a new photo without screenshot album" do
      album = Album.screenshot_of_account(controller.current_account).first
      album.destroy
      params = {format: :json, photo: {description: "description", url: "http://bucket_name.u.qiniudn.com/key"}}
      post :screenshot, params

      ret = { status: "error", message: I18n.t("album.screenshot_not_exists") }
      expect(response.body).to eq ret.to_json
    end


    it "should failed if description is not valid" do
      album = Album.screenshot_of_account(controller.current_account).first
      params = {format: :json, photo: {description: "d"*256, url: "http://bucket_name.u.qiniudn.com/key"}}
      post :screenshot, params

      photo = Photo.where(album_id: album.id).first
      expect(JSON.parse(response.body)["status"]).to eq "fail"
    end
  end
end
