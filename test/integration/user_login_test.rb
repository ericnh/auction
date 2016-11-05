require 'test_helper'

class UserLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:bob)
  end

  test "login with invalid credentials" do
    get login_path
    assert_template 'sessions/new'
    post login_path, session: { email: 'foo@bar.com', password: 'foobar' }
    assert_template 'sessions/new'
    assert flash.present?
    get root_path
    assert_not flash.present?
  end

  test "login with valid credentials" do
    get login_path
    post login_path, session: { email: @user.email, password: 'password' }
    assert is_logged_in?

    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)

    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end
    
end
