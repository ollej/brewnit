require 'rails_helper'

RSpec.describe AddMediumController, type: :controller do
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  describe "POST #create" do
    context "with valid params" do
      it "creates a new AddMedium" do
        expect {
          post :create, params: {add_medium: valid_attributes}, session: valid_session
        }.to change(Medium, :count).by(1)
      end

      it "redirects to the created add_medium" do
        post :create, params: {add_medium: valid_attributes}, session: valid_session
        expect(response).to redirect_to(Medium.last)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: {add_medium: invalid_attributes}, session: valid_session
        expect(response).to be_success
      end
    end
  end
end
