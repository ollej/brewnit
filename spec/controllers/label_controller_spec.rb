require 'rails_helper'

RSpec.describe LabelController, type: :controller do
  let(:recipe) { Recipe.create(recipe_attributes) }
  let(:recipe_attributes) do
    {
      user: user,
      name: 'recipe test'
    }
  end

  login_user

  describe "GET #new" do
    it "returns http success" do
      get :new, params: { id: recipe.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #create" do
    it "returns http success" do
      get :create, params: { id: recipe.id }
      expect(response).to have_http_status(:success)
      expect(response.content_type).to eq "application/pdf"
    end
  end
end
