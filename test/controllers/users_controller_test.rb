require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  def setup
    @user = users(:bob)
    @other_user = users(:pat)
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

  test "should redirect away from index when not logged in" do
    get :index
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect away from update when not logged in" do
    patch :update, id: @user.id, user: {name: @user.name, email: @user.email}
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect away from edit when logged in as the wrong user" do
    log_in_as(@other_user)
    get :edit, id: @user.id
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect away from update when logged in as wrong user" do
    log_in_as(@other_user)
    patch :update, id: @user.id, user: {name: @user.name, email: @user.email}
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should not allow user to update admin status from the scary www" do
    log_in_as(@other_user)
    patch :update, id: @other_user.id, user: {name: @other_user.name, email: @other_user.email, admin: true}
    assert_not @other_user.reload.admin?
  end

  test "should redirect delete request to login page when user not logged in" do
    assert_no_difference 'User.count' do
      delete :destroy, id: @user.id
    end
    assert_redirected_to login_url
  end

  test "should redirect delete request to home page when user is not an admin" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete :destroy, id: @user.id
    end
    assert_redirected_to root_url
  end

  test "should allow delete request when current user is an admin" do
    log_in_as(@user)
    sacrificial_lamb = User.all.last
    assert_difference 'User.count', -1 do
      delete :destroy, id: sacrificial_lamb.id
    end
    assert_redirected_to users_path
  end

end
