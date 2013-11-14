require 'spec_helper'

describe PostsController do
  describe "post is deleted" do
    let(:post_deleted) { create(:deleted_post, post_type: Post::TYPE_TALK) }
    before(:each) do
      request.env["HTTP_REFERER"] = "where_i_came_from"
    end

    [["get", "show"], ["put", "like"], ["delete", "unlike"],
     ["post", "recommend"], ["delete", "destroy"]].each do |item|
      it "#{item[0].upcase} #{item[1]} should show error_message" do
        send(item[0], item[1], {id: post_deleted.id})
        expect(response).to redirect_to "where_i_came_from"
        expect(flash[:error]).to eq I18n.t("messages.posts.deleted")
      end
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
                         original: talk.post,
                         original_author: talk.creator,
                         parent: talk.post)
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
