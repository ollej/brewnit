require 'rails_helper'

RSpec.describe "qr/show.html.erb", type: :view do
  include RecipeContext
  include UserContext

  it "renders qr code" do
    assign(:recipe, recipe)
    assign(:qrcode, "<svg>")

    render

    expect(rendered).to match("<h1>recipe test</h1>")
    expect(rendered).to match("<svg>")
  end
end
