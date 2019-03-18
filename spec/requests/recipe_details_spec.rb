require 'rails_helper'

RSpec.describe "RecipeDetails", type: :request do
  include RecipeContext
  let(:user) { User.create!(name: "test user", email: "test@example.com", password: "abcd1234") }

  before(:each) do
    sign_in user
  end

  describe "GET /recipe_details" do
    it "works! (now write some real specs)" do
      get recipe_details_path(recipe)
      expect(response).to have_http_status(:success)
    end
  end
end
