require 'rails_helper'

RSpec.describe "recipe_ingredients/new", type: :view do
  before(:each) do
    assign(:recipe_ingredient, RecipeIngredient.new())
  end

  it "renders new recipe_ingredient form" do
    render

    assert_select "form[action=?][method=?]", recipe_ingredients_path, "post" do
    end
  end
end
