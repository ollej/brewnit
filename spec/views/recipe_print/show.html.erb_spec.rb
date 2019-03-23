require 'rails_helper'

RSpec.describe "recipe_print/show.html.erb", type: :view do
  include RecipeContext
  include UserContext

  it "renders poster" do
    assign(:recipe, recipe_with_beerxml)
    assign(:beerxml, parsed_beerxml)
    assign(:presenter, recipe_presenter)

    render

    expect(rendered).to match("<h1>recipe test</h1>")
    expect(rendered).to match("IPA")
    expect(rendered).to match("(5 C / SHBF 2015)")
  end
end
