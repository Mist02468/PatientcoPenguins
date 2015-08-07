require 'test_helper'

class PostControllerTest < ActionController::TestCase
  test "should get create" do
    get :create
    assert_response :success
  end

  test "should get comment" do
    get :comment
    assert_response :success
  end

  test "should get upvote" do
    get :upvote
    assert_response :success
  end

end
