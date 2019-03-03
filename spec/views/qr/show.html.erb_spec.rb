require 'rails_helper'

RSpec.describe "qr/show.html.erb", type: :view do
  let(:user) {
    User.create(name: 'devise user', email: 'foo@bar.com', password: 'password')
  }
  let(:recipe) { Recipe.create!(recipe_attributes) }
  let(:recipe_attributes) do
    {
      name: 'recipe test',
      user: user
    }
  end

  it "renders qr code" do
    assign(:recipe, recipe)
    assign(:qrcode, "<svg>")

    render

    expect(rendered).to match("<h1>recipe test</h1>")
    expect(rendered).to match("<svg>")
  end
end
