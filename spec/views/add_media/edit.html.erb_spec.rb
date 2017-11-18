require 'rails_helper'

RSpec.describe "add_media/edit", type: :view do
  before(:each) do
    @add_medium = assign(:add_medium, AddMedium.create!())
  end

  it "renders the edit add_medium form" do
    render

    assert_select "form[action=?][method=?]", add_medium_path(@add_medium), "post" do
    end
  end
end
