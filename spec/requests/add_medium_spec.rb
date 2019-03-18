require 'rails_helper'

RSpec.describe "AddMedium", type: :request do
  include UserContext

  def file_fixture_upload(filename)
    File.open(file_fixture(filename), 'rb')
  end

  let!(:medium) { Medium.create!(parent: parent, file: file_fixture_upload('favicon.png')) }
  let(:params) do
    {
      medium_id: medium.id,
      media_type: media_type
    }
  end

  before(:each) do
    sign_in user
  end

  describe "POST /user/:id/add_medium with media_type avatar" do
    let(:parent) { user }
    let(:media_type) { 'avatar' }

    it "creates medium and redirects to user" do
      post user_add_medium_path(user), params: params
      expect(response).to redirect_to(user)
    end
  end

  describe "POST /user/:id/add_medium with media_type brewery" do
    let(:parent) { user }
    let(:media_type) { 'brewery' }

    it "creates medium and redirects to user" do
      post user_add_medium_path(user), params: params
      expect(response).to redirect_to(user)
    end
  end

  describe "POST /event/:id/add_medium" do
    let(:event) { Event.create!(event_attributes) }
    let(:event_attributes) do
      {
        name: 'event name',
        organizer: 'organizer name',
        held_at: DateTime.now,
        event_type: Event::EVENT_TYPES.first,
        user: user
      }
    end
    let(:parent) { event }
    let(:media_type) { 'main' }

    it "creates medium and redirects to event" do
      post event_add_medium_path(event), params: params
      expect(response).to redirect_to(event)
    end
  end

  describe "POST /recipe/:id/add_medium" do
    include RecipeContext
    let(:parent) { recipe }
    let(:media_type) { 'main' }

    it "creates medium and redirects to recipe" do
      post recipe_add_medium_path(recipe), params: params
      expect(response).to redirect_to(recipe)
    end
  end
end
