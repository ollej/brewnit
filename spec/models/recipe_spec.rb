require 'rails_helper'

RSpec.describe Recipe, type: :model do
  include RecipeContext

  let(:user) { User.new }

  describe 'validations' do
    it 'does not require a beerxml' do
      expect(recipe).to be_valid
    end

    it 'requires a user' do
      recipe.user = nil
      expect(recipe).not_to be_valid
    end
  end

  describe '#owned_by?' do
    it 'is true for same user' do
      expect(recipe.owned_by?(user)).to be true
    end

    it 'is false for other user' do
      other_user = User.new
      expect(recipe.owned_by?(other_user)).to be false
    end
  end
end
