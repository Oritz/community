require 'spec_helper'

describe GroupsController do
  describe "GET index" do
    let(:groups) { create_list(:group, 25) }

    it "should show groups with user login"

    it "should show groups without page" do
      get :index
      expect(assigns(:groups)).to eq(groups[0..9])
    end

    it "should show groups with page" do
      pending "to be done"
      get :index, page: 2
      expect(assigns(:groups)).to eq(groups[10..19])
    end
  end

  describe "GET show" do
    it "should show details of a group" do
      pending "need tags, newcommers, subjects"
      group = create(:group)
      tags = create_list(:tag, groups: [group])

      get :show, id: group.id
      expect(assigns(:group)).to eq group
      expect(assigns(:tags)).to eq tags
    end
  end

  context "need authority" do
    describe "GET new" do
      it "should not render page without authority"
      it "should render page with authority"
    end

    describe "GET edit" do
      it "should not render edit page with authority"
      it "should render eidt page with authority"
    end

    describe "POST create" do
      it "create a new group"
      it "should not create a new group without authority"
    end

    describe "PUT update" do
      it "save a group"
      it "should not save a group without authority"
    end

    describe "DELETE destroy" do
      it "delete a group"
      it "should not delete a group withour authority"
    end
  end

  describe "PUT add_user" do
    it "should be added by a user"
  end

  describe "DELETE remove_user" do
    it "should be quited by a user"
  end

  describe "POST add_tags"
end
