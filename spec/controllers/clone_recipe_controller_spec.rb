require 'rails_helper'

RSpec.describe CloneRecipeController, type: :controller do
  include RecipeContext
  login_user

  let(:other_user) {
    user = User.new(name: 'other user', email: 'foo@example.com', password: 'password')
    user.skip_confirmation!
    user.save!
    user
  }
  let(:recipe_with_beerxml_attributes) do
    {
      user: other_user,
      name: 'recipe test',
      beerxml: beerxml
    }
  end

  describe "GET #new" do
    it "returns http success" do
      get :new, params: { id: recipe_with_beerxml.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #create" do
    it "returns http success and clones recipe with new name" do
      post :create, params: { id: recipe_with_beerxml.id, name: "foo bar" }
      cloned_recipe = Recipe.last
      expect(response).to redirect_to(cloned_recipe)
      expect(cloned_recipe.id).not_to eq recipe_with_beerxml.id
      expect(cloned_recipe).to have_attributes(
        name: "foo bar",
        beerxml: beerxml,
        user: user
      )
    end
  end
end
