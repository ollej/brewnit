require 'rails_helper'

RSpec.describe "recipe_details/index", type: :view do
  before(:each) do
    assign(:recipe_details, [
      RecipeDetail.create!(),
      RecipeDetail.create!()
    ])
  end

  it "renders a list of recipe_details" do
    render
  end
end
