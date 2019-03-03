require 'rails_helper'

RSpec.describe CloneRecipeController, type: :controller do
  let(:other_user) {
    user = User.new(name: 'other user', email: 'foo@example.com', password: 'password')
    user.skip_confirmation!
    user.save!
    user
  }
  let(:recipe) { Recipe.create(recipe_attributes) }
  let(:beerxml) { file_fixture('beerxml.xml').read }
  let(:recipe_attributes) do
    {
      user: other_user,
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
      expect(cloned_recipe).to have_attributes(
        name: "foo bar",
        beerxml: beerxml,
        user: user
      )
    end
  end
end
