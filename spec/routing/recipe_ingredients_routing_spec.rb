require "rails_helper"

RSpec.describe RecipeIngredientsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/recipe_ingredients").to route_to("recipe_ingredients#index")
    end

    it "routes to #new" do
      expect(:get => "/recipe_ingredients/new").to route_to("recipe_ingredients#new")
    end

    it "routes to #show" do
      expect(:get => "/recipe_ingredients/1").to route_to("recipe_ingredients#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/recipe_ingredients/1/edit").to route_to("recipe_ingredients#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/recipe_ingredients").to route_to("recipe_ingredients#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/recipe_ingredients/1").to route_to("recipe_ingredients#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/recipe_ingredients/1").to route_to("recipe_ingredients#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/recipe_ingredients/1").to route_to("recipe_ingredients#destroy", :id => "1")
    end

  end
end
