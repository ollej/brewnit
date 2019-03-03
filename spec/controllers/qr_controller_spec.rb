require 'rails_helper'

RSpec.describe QrController, type: :controller do
  let(:user) {
    User.create(name: 'devise user', email: 'foo@bar.com', password: 'password')
  }
  let(:recipe) { Recipe.create!(recipe_attributes) }
  let(:recipe_attributes) do
    {
      name: 'recipe test',
      user: user
    }
  end

  describe "GET #show" do
    it "returns http success" do
      get :show, params: { id: recipe.id }
      expect(response).to have_http_status(:success)
    end
  end
end
