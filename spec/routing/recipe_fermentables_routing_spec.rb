require "rails_helper"

RSpec.describe RecipeFermentablesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/recipe_fermentables").to route_to("recipe_fermentables#index")
    end

    it "routes to #create" do
      expect(:post => "/recipe_fermentables").to route_to("recipe_fermentables#create")
    end

    it "routes to #destroy" do
      expect(:delete => "/recipe_fermentables/1").to route_to("recipe_fermentables#destroy", :id => "1")
    end

  end
end
