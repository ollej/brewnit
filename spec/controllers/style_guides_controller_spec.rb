require 'rails_helper'

RSpec.describe StyleGuidesController, type: :controller do
  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #show" do
    let(:style) { Style.create!(style_attributes) }
    let(:style_attributes) do
      {
        name: "stiltyp",
        style_guide: "foo 2019",
        number: 42,
        letter: 'Z'
      }
    end

    it "returns http success" do
      get :show, params: { guide: style.name }
      expect(response).to have_http_status(:success)
    end
  end
end
