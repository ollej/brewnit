require "rails_helper"

RSpec.describe RecipeDetailsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/recipe_details").to route_to("recipe_details#index")
    end

    it "routes to #new" do
      expect(:get => "/recipe_details/new").to route_to("recipe_details#new")
    end

    it "routes to #show" do
      expect(:get => "/recipe_details/1").to route_to("recipe_details#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/recipe_details/1/edit").to route_to("recipe_details#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/recipe_details").to route_to("recipe_details#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/recipe_details/1").to route_to("recipe_details#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/recipe_details/1").to route_to("recipe_details#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/recipe_details/1").to route_to("recipe_details#destroy", :id => "1")
    end

  end
end
