require 'rails_helper'

RSpec.describe RecipesController, type: :controller do
  include RecipeContext
  login_user

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  let(:valid_session) { {} }

  describe "GET #index" do
    it "returns a success response" do
      recipe
      get :index, params: {}, session: valid_session
      expect(response).to be_success
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      get :show, params: {id: recipe.to_param}, session: valid_session
      expect(response).to be_success
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new, params: {}, session: valid_session
      expect(response).to be_success
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      get :edit, params: {id: recipe.to_param}, session: valid_session
      expect(response).to be_success
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Recipe" do
        expect {
          post :create, params: {recipe: recipe_attributes}, session: valid_session
        }.to change(Recipe, :count).by(1)
      end

      it "redirects to the created recipe" do
        post :create, params: {recipe: recipe_attributes}, session: valid_session
        expect(response).to redirect_to(Recipe.last)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: {recipe: invalid_attributes}, session: valid_session
        expect(response).to be_success
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested recipe" do
        put :update, params: {id: recipe.to_param, recipe: new_attributes}, session: valid_session
        recipe.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the recipe" do
        put :update, params: {id: recipe.to_param, recipe: recipe_attributes}, session: valid_session
        expect(response).to redirect_to(recipe)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        put :update, params: {id: recipe.to_param, recipe: invalid_attributes}, session: valid_session
        expect(response).to be_success
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested recipe" do
      expect {
        delete :destroy, params: {id: recipe.to_param}, session: valid_session
      }.to change(Recipe, :count).by(-1)
    end

    it "redirects to the recipes list" do
      delete :destroy, params: {id: recipe.to_param}, session: valid_session
      expect(response).to redirect_to(recipes_url)
    end
  end
end
