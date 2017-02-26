require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  def setup
    @user = users(:bob)
  end

  test "should get new" do
    get :new
    assert_response :success
    assert_select "title", "Sign Up | Guatemala Silent Auction"
  end

  test "should redirect away from edit when not logged in" do
    get :edit, id: @user.id
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect away from update when not logged in" do
    patch :update, id: @user.id, user: {name: @user.name, email: @user.email}
    assert_not flash.empty?
    assert_redirected_to login_url
  end

end
