require 'spec_helper'

describe HomeController do
  describe "need login" do
    pending "TO BE DONE"
  end

  describe "logged in" do
    describe "GET index" do
      it "should show current user's info"
    end

    describe "GET groups" do
      login_account

      it "should show groups which are added" do
        groups = create_list(:group, 20)

        now = Time.now
        groups.each_with_index do |g, index|
          Timecop.freeze(now + 1000 * index)
          g.accounts << controller.current_account
          Timecop.return
        end

        get :groups

        expect(assigns(:groups)).to eq groups[0..9]
      end
    end

    describe "GET people" do
      it "should show following users"
      it "should show followers"
    end

    describe "GET games" do
      it "should show games which are owned"
    end

    describe "GET posts" do
      it "should show posts which are posted by following users"

      it "should show posts which are posted in the groups added"
    end

    describe "GET recommended" do
      it "should show posts which are recommended"
    end

    describe "GET notification" do
      it "should show notification"
    end
  end
end
