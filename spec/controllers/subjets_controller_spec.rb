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

    it "should failed without authority"
  end
end
