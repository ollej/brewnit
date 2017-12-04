require 'rails_helper'

RSpec.describe RegisterRecipeController, type: :controller do

  describe 'GET #new' do
    it 'redirects to new_session_url' do
      get :new
      expect(response).to redirect_to new_user_session_url
    end

    describe 'with logged in user' do
      login_user

      it 'returns http success' do
        get :new
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'POST #create' do
    subject(:create) {
      post :create, params: { registration: valid_attributes }
    }

    it 'redirects to new_session_url' do
      post :create
      expect(response).to redirect_to new_user_session_url
    end

    describe 'with logged in user' do
      login_user

      let(:beerxml) { file_fixture('beerxml.xml').read }
      let(:recipe) { Recipe.create!(beerxml: beerxml, user: user) }
      let(:event) {
        Event.create!(
          name: 'official event',
          official: true,
          organizer: 'someone',
          event_type: 'Tävling',
          user: user,
          held_at: Date.tomorrow
        )
      }
      let(:valid_attributes) {
        {
          recipe: recipe.id,
          event: event.id,
          message: 'foobar'
        }
      }

      it 'redirects to event' do
        create
        expect(response).to redirect_to event_path(event)
      end

      it 'creates an event registration' do
        expect { create }.to change { EventRegistration.count }.by(+1)
        last_reg = EventRegistration.last
        expect(last_reg.event).to eq event
        expect(last_reg.recipe).to eq recipe
        expect(last_reg.user).to eq user
        expect(last_reg.message).to eq 'foobar'
      end
    end
  end

end
