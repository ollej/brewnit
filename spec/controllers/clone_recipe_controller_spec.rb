require 'rails_helper'

RSpec.describe CloneRecipeController, type: :controller do
  let(:recipe) { Recipe.create(recipe_attributes) }
  let(:beerxml) { file_fixture('beerxml.xml').read }
  let(:recipe_attributes) do
    {
      user: user,
      name: 'recipe test',
      beerxml: beerxml
    }
  end

  describe "GET #new" do
    login_user

    it "returns http success" do
      get :new, params: { id: recipe.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #create" do
    login_user

    it "returns http success and clones recipe with new name" do
      post :create, params: { id: recipe.id, name: "foo bar" }
      cloned_recipe = Recipe.last
      expect(response).to redirect_to(cloned_recipe)
      expect(cloned_recipe.id).not_to eq recipe.id
      expect(cloned_recipe.name).to eq "foo bar"
      expect(cloned_recipe.beerxml).to eq beerxml
    end
  end
end
