require 'rails_helper'

RSpec.describe RecipeDetailsController, type: :controller do
  let(:beerxml) { file_fixture('beerxml.xml').read }
  let(:recipe) { Recipe.create!(beerxml: beerxml, user: user) }
  let!(:recipe_detail) { RecipeDetail.create! valid_attributes }
  # TODO: Add ingredients
  let(:valid_attributes) {
    {
      batch_size: 20.0,
      efficiency: 72.0,
      recipe: recipe
    }
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  let(:valid_session) { {} }

  describe 'GET #show' do
    subject(:get_show) do
      get :show, params: { recipe_id: recipe.id }, session: valid_session
    end

    login_user

    it 'returns a success response' do
      get_show
      expect(response).to be_success
    end

    it 'assigns recipe ingredients' do
      get_show
      expect(assigns(:details)).to eq recipe_detail
      expect(assigns(:hops)).to eq recipe_detail.hops
      expect(assigns(:fermentables)).to eq recipe_detail.fermentables
      expect(assigns(:miscs)).to eq recipe_detail.miscs
      expect(assigns(:yeasts)).to eq recipe_detail.yeasts
    end

    it "creates a RecipeDetail for recipe if it doesn't exist"
  end

end
