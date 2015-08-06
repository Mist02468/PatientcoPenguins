require 'test_helper'

class EventControllerTest < ActionController::TestCase
  test "should get create" do
    get :create
    assert_response :success
  end

  test "should get join" do
    get :join
    assert_response :success
  end

  test "should get invite" do
    get :invite
    assert_response :success
  end

end
