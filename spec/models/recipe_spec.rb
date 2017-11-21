require 'rails_helper'

RSpec.describe Recipe, type: :model do
  let(:user) { User.new() }
  let(:recipe) { Recipe.new(valid_attributes) }
  let(:beerxml) { file_fixture('beerxml.xml').read }
  let(:valid_attributes) do
    {
      user: user
    }
  end

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

  describe '#complete?' do
    it 'defaults to not complete' do
      expect(recipe.complete?).to be false
    end

    it 'gets set to true if beerxml exists' do
      recipe.beerxml = beerxml
      recipe.save!
      expect(recipe.complete?).to be true
    end
  end
end
