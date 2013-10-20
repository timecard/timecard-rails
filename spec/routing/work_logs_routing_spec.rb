require "spec_helper"

describe WorkLogsController do
  describe "routing" do

    it "routes to #index" do
      get("/work_logs").should route_to("work_logs#index")
    end

    it "routes to #new" do
      get("/work_logs/new").should route_to("work_logs#new")
    end

    it "routes to #show" do
      get("/work_logs/1").should route_to("work_logs#show", :id => "1")
    end

    it "routes to #edit" do
      get("/work_logs/1/edit").should route_to("work_logs#edit", :id => "1")
    end

    it "routes to #create" do
      post("/work_logs").should route_to("work_logs#create")
    end

    it "routes to #update" do
      put("/work_logs/1").should route_to("work_logs#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/work_logs/1").should route_to("work_logs#destroy", :id => "1")
    end

  end
end
