require 'rails_helper'

RSpec.describe "add_media/index", type: :view do
  before(:each) do
    assign(:add_media, [
      AddMedium.create!(),
      AddMedium.create!()
    ])
  end

  it "renders a list of add_media" do
    render
  end
end
