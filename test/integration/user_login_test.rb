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

  test "login and logout with valid credentials" do
    # login
    get login_path
    post login_path, session: { email: @user.email, password: 'password' }
    assert is_logged_in?

    # check to make sure we get the logged in view
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)

    # logout
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url

    # simulate the user clicking logout again from a different window
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", user_path(@user), count: 0

    # simulate logging out a second time from a concurrent session
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end

  test "login with remembering" do
    log_in_as(@user, remember_me: '1')
    assert_equal cookies['remember_token'], assigns(:user).remember_token
  end

  test "login without remembering" do
    # set the token normally first
    log_in_as(@user, remember_me: '1')
    assert_not_empty cookies['remember_token']
    # then confirm the token is unset on the second login
    log_in_as(@user, remember_me: '0')
    assert_empty cookies['remember_token']
  end
end
