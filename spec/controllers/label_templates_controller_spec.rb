require 'rails_helper'

RSpec.describe LabelTemplatesController, type: :controller do
  describe "GET #show" do
    it "returns http success" do
      get :show, params: { template: 'back-label' }
      expect(response).to have_http_status(:success)
      expect(response.content_type).to eq("image/svg+xml")
      expect(response.body).to start_with("<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>\n<svg")
    end
  end
end
