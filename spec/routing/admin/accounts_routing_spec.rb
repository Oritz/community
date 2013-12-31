require "spec_helper"

describe Admin::AccountsController do
  describe "routing" do

    it "routes to #index" do
      get("/admin/accounts").should route_to("admin/accounts#index")
    end

    it "routes to #new" do
      get("/admin/accounts/new").should route_to("admin/accounts#new")
    end

    it "routes to #show" do
      get("/admin/accounts/1").should route_to("admin/accounts#show", :id => "1")
    end

    it "routes to #edit" do
      get("/admin/accounts/1/edit").should route_to("admin/accounts#edit", :id => "1")
    end

    it "routes to #create" do
      post("/admin/accounts").should route_to("admin/accounts#create")
    end

    it "routes to #update" do
      put("/admin/accounts/1").should route_to("admin/accounts#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/admin/accounts/1").should route_to("admin/accounts#destroy", :id => "1")
    end

  end
end
