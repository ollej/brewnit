require 'rails_helper'

RSpec.describe QrController, type: :controller do
  include RecipeContext
  login_user

  describe "GET #show" do
    it "returns http success" do
      get :show, params: { id: recipe.id }
      expect(response).to have_http_status(:success)
    end
  end
end
