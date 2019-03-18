require 'rails_helper'

RSpec.describe LabelController, type: :controller do
  include RecipeContext
  login_user

  describe "GET #new" do
    it "returns http success" do
      get :new, params: { id: recipe.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #create" do
    it "returns http success" do
      post :create, params: { id: recipe.id }
      expect(response).to have_http_status(:success)
      expect(response.content_type).to eq "application/pdf"
    end
  end
end
