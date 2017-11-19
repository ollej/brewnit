require 'rails_helper'

RSpec.describe "recipe_ingredients/index", type: :view do
  before(:each) do
    assign(:recipe_ingredients, [
      RecipeIngredient.create!(),
      RecipeIngredient.create!()
    ])
  end

  it "renders a list of recipe_ingredients" do
    render
  end
end
