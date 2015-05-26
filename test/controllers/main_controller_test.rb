require 'test_helper'

class MainControllerTest < ActionController::TestCase
  test "should get browse" do
    get :browse
    assert_response :success
  end

end
