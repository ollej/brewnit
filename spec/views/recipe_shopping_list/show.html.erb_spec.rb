require 'rails_helper'

RSpec.describe "recipe_shopping_list/show.html.erb", type: :view do
  include RecipeContext
  include UserContext

  let(:shopping) { ShoppingList.new(recipe).build }

  it "renders poster" do
    assign(:recipe, recipe_with_beerxml)
    assign(:presenter, recipe_presenter)
    assign(:shopping, shopping)

    render

    expect(rendered).to match("<h1>#{I18n.t(:'recipe_shopping_list.header')} recipe test</h1>")
  end
end
