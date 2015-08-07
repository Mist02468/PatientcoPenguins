require 'test_helper'

class SearchControllerTest < ActionController::TestCase
  test "should get searchByTag" do
    get :searchByTag
    assert_response :success
  end

  test "should get searchByText" do
    get :searchByText
    assert_response :success
  end

  test "should get searchByUser" do
    get :searchByUser
    assert_response :success
  end

end
