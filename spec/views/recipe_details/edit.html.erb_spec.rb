require 'rails_helper'

RSpec.describe "recipe_details/edit", type: :view do
  before(:each) do
    @recipe_detail = assign(:recipe_detail, RecipeDetail.create!())
  end

  it "renders the edit recipe_detail form" do
    render

    assert_select "form[action=?][method=?]", recipe_detail_path(@recipe_detail), "post" do
    end
  end
end
