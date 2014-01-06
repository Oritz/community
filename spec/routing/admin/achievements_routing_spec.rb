require "spec_helper"

describe Admin::AchievementsController do
  describe "routing" do

    it "routes to #index" do
      get("/admin/achievements").should route_to("admin/achievements#index")
    end

    it "routes to #new" do
      get("/admin/achievements/new").should route_to("admin/achievements#new")
    end

    it "routes to #show" do
      get("/admin/achievements/1").should route_to("admin/achievements#show", :id => "1")
    end

    it "routes to #edit" do
      get("/admin/achievements/1/edit").should route_to("admin/achievements#edit", :id => "1")
    end

    it "routes to #create" do
      post("/admin/achievements").should route_to("admin/achievements#create")
    end

    it "routes to #update" do
      put("/admin/achievements/1").should route_to("admin/achievements#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/admin/achievements/1").should route_to("admin/achievements#destroy", :id => "1")
    end

  end
end
