require 'rails_helper'

RSpec.describe "recipe_ingredients/edit", type: :view do
  before(:each) do
    @recipe_ingredient = assign(:recipe_ingredient, RecipeIngredient.create!())
  end

  it "renders the edit recipe_ingredient form" do
    render

    assert_select "form[action=?][method=?]", recipe_ingredient_path(@recipe_ingredient), "post" do
    end
  end
end
