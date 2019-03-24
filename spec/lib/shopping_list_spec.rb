require 'rails_helper'

RSpec.describe ShoppingList do
  include RecipeContext
  subject { ShoppingList.new(recipe_with_beerxml) }

  def fermentable(name, amount)
    {
      name: name,
      type: I18n.t(:'recipe_shopping_list.type.fermentable'),
      amount: amount,
      unit: I18n.t(:'recipe_shopping_list.units.kg')
    }
  end

  def hop(name, amount)
    {
      name: name,
      type: I18n.t(:'recipe_shopping_list.type.hops'),
      amount: amount,
      unit: I18n.t(:'recipe_shopping_list.units.gr')
    }
  end

  describe '#build' do
    it "returns self" do
      expect(subject.build).to be subject
    end

    it "delegates building to methods for each ingredient" do
      expect(subject).to receive(:build_fermentables)
      expect(subject).to receive(:build_hops)
      expect(subject).to receive(:build_yeasts)
      expect(subject).to receive(:build_miscs)
      subject.build
    end
  end

  describe '#items' do
    it 'returns empty items array' do
      expect(subject.items).to eq []
    end

    context 'after #build' do
      it 'returns built items' do
        # TODO: Add misc in beerxml
        # TODO: Order items by amount
        # TODO: Fix amount for misc
        expect(subject.build.items).to include(
          have_attributes(fermentable("Pale Ale", 4.25)),
          have_attributes(fermentable("Carahell (Weyermann)", 0.28)),
          have_attributes(fermentable("Crystal 400 (Dark Crystal)", 0.05)),
          have_attributes(hop("Eureka!", 198)),
          have_attributes(
            name: "Safale American US-05",
            type: I18n.t(:'recipe_shopping_list.type.yeast'),
            amount: 1,
            unit: I18n.t(:'recipe_shopping_list.units.packet')
          )
        )
        #pp subject.items.inspect
      end
    end
  end
end
