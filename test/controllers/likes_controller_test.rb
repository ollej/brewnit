require 'test_helper'

class LikesControllerTest < ActionController::TestCase
  test "should like recipe" do
    get :create
    assert_response :success
  end

end
