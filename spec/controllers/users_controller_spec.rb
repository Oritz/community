require 'spec_helper'

describe UsersController do
  describe "need login" do
    describe "PUT follow" do
      it "should redirect to login page"
    end

    describe "DELETE unfollow" do
      it "should redirect to login page"
    end
  end

  let(:user) { create(:account) }

  describe "GET show" do
    it "should render show page" do
      get :show, id: user.id

      expect(assigns(:target)).to eq user
    end
  end

  describe "GET groups" do
    it "should render group page" do
      groups = create_list(:group, 20)

      now = Time.now
      groups.each_with_index do |g, index|
        Timecop.freeze(now + 1000 * index)
        g.accounts << user
        Timecop.return
      end

      get :groups, id: user.id

      expect(assigns(:target)).to eq user
      expect(assigns(:groups)).to eq groups[0..9]
    end
  end

  describe "GET posts" do
    it "should return posts info via json"
  end

  describe "GET people" do
    it "should show followers info"
    it "should show followings info"
  end

  describe "PUT follow" do
    it "should follow a user"
  end

  describe "DELETE unfollow" do
    it "should unfollow a user"
  end
end
