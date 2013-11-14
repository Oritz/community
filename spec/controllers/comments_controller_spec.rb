require 'spec_helper'

describe CommentsController do
  let(:talk) { create(:talk) }

  describe "need login" do
    #should_login("post", "create", {post_id: talk_id})
    #should_login("delete", "destroy", {post_id: talk_id, id: comment_id})
    #should_login("get", "in")
    #should_login("get", "out")
  end

  describe "post is deleted" do
    login_account
    pending "TO BE DONE"
  end

  describe "GET index"

  login_account

  describe "POST create"

  describe "DELETE destroy"

  describe "GET in"

  describe "GET out"
end
