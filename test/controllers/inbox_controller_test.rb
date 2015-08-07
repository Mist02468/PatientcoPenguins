require 'test_helper'

class InboxControllerTest < ActionController::TestCase
  test "should get send" do
    get :send
    assert_response :success
  end

  test "should get read" do
    get :read
    assert_response :success
  end

end
