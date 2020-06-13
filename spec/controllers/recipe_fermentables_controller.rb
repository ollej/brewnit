require 'rails_helper'

RSpec.describe RecipeFermentablesController, type: :controller do
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  let(:valid_session) { {} }

  describe "GET #index" do
    it "returns a success response" do
      Fermentable.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to be_success
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Fermentable" do
        expect {
          post :create, params: {fermentable: valid_attributes}, session: valid_session
        }.to change(Fermentable, :count).by(1)
      end

      it "redirects to the created fermentable" do
        post :create, params: {fermentable: valid_attributes}, session: valid_session
        expect(response).to redirect_to(Fermentable.last)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: {fermentable: invalid_attributes}, session: valid_session
        expect(response).to be_success
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested fermentable" do
        fermentable = Fermentable.create! valid_attributes
        put :update, params: {id: fermentable.to_param, fermentable: new_attributes}, session: valid_session
        fermentable.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the fermentable" do
        fermentable = Fermentable.create! valid_attributes
        put :update, params: {id: fermentable.to_param, fermentable: valid_attributes}, session: valid_session
        expect(response).to redirect_to(fermentable)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        fermentable = Fermentable.create! valid_attributes
        put :update, params: {id: fermentable.to_param, fermentable: invalid_attributes}, session: valid_session
        expect(response).to be_success
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested fermentable" do
      fermentable = Fermentable.create! valid_attributes
      expect {
        delete :destroy, params: {id: fermentable.to_param}, session: valid_session
      }.to change(Fermentable, :count).by(-1)
    end

    it "redirects to the fermentables list" do
      fermentable = Fermentable.create! valid_attributes
      delete :destroy, params: {id: fermentable.to_param}, session: valid_session
      expect(response).to redirect_to(fermentables_url)
    end
  end
end
