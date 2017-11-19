require 'rails_helper'

RSpec.describe "add_media/show", type: :view do
  before(:each) do
    @add_medium = assign(:add_medium, AddMedium.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
