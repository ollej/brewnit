require 'rails_helper'

RSpec.describe "RecipeDetails", type: :request do
  describe "GET /recipe_details" do
    it "works! (now write some real specs)" do
      get recipe_details_path
      expect(response).to have_http_status(200)
    end
  end
end
