require 'rails_helper'

RSpec.describe "recipe_poster/show.html.erb", type: :view do
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
    expect(rendered).to match(%Q{<img src="https://api.adorable.io/avatars/64/55502f40dc8b7c769880b10874abc9d0" />})
  end
end
