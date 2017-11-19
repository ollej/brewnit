require 'rails_helper'

RSpec.describe "recipe_ingredients/show", type: :view do
  before(:each) do
    @recipe_ingredient = assign(:recipe_ingredient, RecipeIngredient.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
