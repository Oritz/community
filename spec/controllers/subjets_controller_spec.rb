require 'spec_helper'

describe SubjectsController do
  describe "GET show" do
    it "should show a subject with comments" do
    end
  end

  describe "GET new" do
    it "should render new page by author"
    it "should failed without authority"
  end

  describe "POST create" do
    it "should create a subject"
  end

  describe "GET edit" do
    it "should render edit page by author"
    it "should failed without authority"
  end

  describe "PUT update" do
    login_account
    let!(:subject) { create(:subject, creator: controller.current_account) }
    let!(:post_images) { create_list(:post_image, 5, post: subject.post) }

    it "should update content by author" do
      params = {format: :json, subject: {content: "content_new", title: "title_new"}, id: subject.id}
      put :update, params

      subject_db = Subject.find(subject.id)
      expect(subject_db.content).to eq "content_new"
      expect(subject_db.title).to eq "title_new"
      expect(JSON.parse(response.body)["status"]).to eq "success"
    end

    it "should post a subject" do
      params = {format: :json, subject: {content: "content_new", title: "title_new"}, id: subject.id, is_post: 1}
      put :update, params

      ret = { status: "success", data: { id: subject.id, post: {id: subject.post.id} } }
      expect(response.body).to eq ret.to_json
      expect(subject.status).to eq Post::STATUS_NORMAL
    end

    it "should failed if post a subject which is deleted" do
      subject.status = Post::STATUS_DELETED
      subject.save!

      params = {format: :json, subject: {content: "content_new", title: "title_new"}, id: subject.id, is_post: 1}
      put :update, params

      ret = { status: "error", message: I18n.t("post.is_deleted") }
      expect(response.body).to eq ret.to_json
    end

    it "should failed without authority"
  end
end
