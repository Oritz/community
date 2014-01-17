require 'spec_helper'

describe PostsController do
  describe "post is deleted" do
    login_account
    let(:post_deleted) { create(:deleted_post) }
    before(:each) do
      request.env["HTTP_REFERER"] = "where_i_came_from"
    end

    [["get", "show", "edit"], ["put", "like", "update"], ["delete", "unlike"],
     ["post", "recommend"], ["delete", "destroy"]].each do |item|
      it "#{item[0].upcase} #{item[1]} should show error_message" do
        send(item[0], item[1], {id: post_deleted.id})
        expect(response).to redirect_to "where_i_came_from"
        expect(flash[:error]).to eq I18n.t("messages.posts.deleted")
      end
    end
  end

  describe "POST create" do
    render_views
    context "with json" do
      login_account
      let(:account) { create(:account) }

      it "should create a talk without image" do
        params = {format: :json, post: {content: "content"}}
        post :create, params

        new_post = Post.first
        body = JSON.parse(response.body)
        expect(body["status"]).to eq "success"
        expect(body["data"]["id"]).to eq new_post.id
      end

      it "should create a talk with image" do
        cloud_storage = create(:cloud_storage)
        params = {format: :json, post: {content: "content", cloud_storage_id: cloud_storage.id}}
        post :create, params

        new_post = Post.first
        body = JSON.parse(response.body)
        expect(body["status"]).to eq "success"
        expect(body["data"]["id"]).to eq new_post.id
        expect(body["data"]["image_url"]).to eq cloud_storage.url
      end
    end
  end

  describe "GET new"

  describe "GET edit"

  describe "PUT update" do
    render_views
    login_account
    let!(:post) { create(:subject, creator: controller.current_account) }
    let!(:post_images) { create_list(:post_image, 5, post: post) }

    it "should update content by author" do
      params = {format: :json, post: {content: "content_new", main_body: "main_new"}, id: post.id}
      put :update, params

      subject = Post.find(post.id)
      expect(subject.content).to eq "content_new"
      expect(subject.main_body).to eq "main_new"
      expect(JSON.parse(response.body)["status"]).to eq "success"
    end

    it "should post a subject" do
      params = {format: :json, post: {content: "content_new", main_body: "main_new"}, id: post.id, is_post: 1}
      put :update, params

      ret = { status: "success", data: { id: post.id } }
      expect(response.body).to eq ret.to_json
      expect(post.is_normal?).to be_true
    end
  end

  describe "GET show" do
    it "should render a talk" do
      talk = create(:talk)
      get :show, id: talk.id

      expect(assigns(:post)).to eq talk
    end

    it "should render a subject" do
      subject = create(:subject)
      get :show, id: subject.id

      expect(assigns(:post)).to eq subject
    end

    it "should render a post recommended" do
      talk = create(:talk)
      recommend = create(:recommend,
                         original: talk,
                         original_author: talk.creator,
                         parent: talk)
      get :show, id: recommend.id

      expect(assigns(:post)).to eq recommend
    end
  end

  describe "DELETE destroy" do
    it "deletes a post"
  end

  describe "PUT like" do
    it "should be liked by a user"
    it "should not be liked by a user who already liked"
  end

  describe "DELETE unlike" do
    it "should be unliked by a user who already liked"
    it "should not be unliked by a user who dosen't already liked"
  end

  describe "POST recommend" do
    it "should be recommended by a user"
  end
end
