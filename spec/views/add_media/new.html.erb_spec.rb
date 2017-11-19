require 'rails_helper'

RSpec.describe "add_media/new", type: :view do
  before(:each) do
    assign(:add_medium, AddMedium.new())
  end

  it "renders new add_medium form" do
    render

    assert_select "form[action=?][method=?]", add_media_path, "post" do
    end
  end
end
