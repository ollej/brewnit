require 'rails_helper'

RSpec.describe "AddMedia", type: :request do
  describe "GET /add_media" do
    it "works! (now write some real specs)" do
      get add_media_path
      expect(response).to have_http_status(200)
    end
  end
end
