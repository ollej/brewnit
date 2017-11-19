require 'rails_helper'

RSpec.describe "recipe_details/show", type: :view do
  before(:each) do
    @recipe_detail = assign(:recipe_detail, RecipeDetail.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
