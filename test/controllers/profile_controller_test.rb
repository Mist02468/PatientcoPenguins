require 'test_helper'

class ProfileControllerTest < ActionController::TestCase
  test "should get report" do
    get :report
    assert_response :success
  end

  test "should get message" do
    get :message
    assert_response :success
  end

  test "should get subscribe" do
    get :subscribe
    assert_response :success
  end

end
