require "rails_helper"

RSpec.describe AddMediaController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/add_media").to route_to("add_media#index")
    end

    it "routes to #new" do
      expect(:get => "/add_media/new").to route_to("add_media#new")
    end

    it "routes to #show" do
      expect(:get => "/add_media/1").to route_to("add_media#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/add_media/1/edit").to route_to("add_media#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/add_media").to route_to("add_media#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/add_media/1").to route_to("add_media#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/add_media/1").to route_to("add_media#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/add_media/1").to route_to("add_media#destroy", :id => "1")
    end

  end
end
