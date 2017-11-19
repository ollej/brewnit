require 'rails_helper'

RSpec.describe "RecipeIngredients", type: :request do
  describe "GET /recipe_ingredients" do
    it "works! (now write some real specs)" do
      get recipe_ingredients_path
      expect(response).to have_http_status(200)
    end
  end
end
