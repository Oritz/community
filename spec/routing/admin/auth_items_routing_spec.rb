require "spec_helper"

describe Admin::AuthItemsController do
  describe "routing" do

    it "routes to #index" do
      get("/admin/auth_items").should route_to("admin/auth_items#index")
    end

    it "routes to #new" do
      get("/admin/auth_items/new").should route_to("admin/auth_items#new")
    end

    it "routes to #show" do
      get("/admin/auth_items/1").should route_to("admin/auth_items#show", :id => "1")
    end

    it "routes to #edit" do
      get("/admin/auth_items/1/edit").should route_to("admin/auth_items#edit", :id => "1")
    end

    it "routes to #create" do
      post("/admin/auth_items").should route_to("admin/auth_items#create")
    end

    it "routes to #update" do
      put("/admin/auth_items/1").should route_to("admin/auth_items#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/admin/auth_items/1").should route_to("admin/auth_items#destroy", :id => "1")
    end

  end
end
