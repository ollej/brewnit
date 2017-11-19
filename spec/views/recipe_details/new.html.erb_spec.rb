require 'rails_helper'

RSpec.describe "recipe_details/new", type: :view do
  before(:each) do
    assign(:recipe_detail, RecipeDetail.new())
  end

  it "renders new recipe_detail form" do
    render

    assert_select "form[action=?][method=?]", recipe_details_path, "post" do
    end
  end
end
