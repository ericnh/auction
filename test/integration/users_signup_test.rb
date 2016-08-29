require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  test "User model validations" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, user: { name: "",
                               email: "user@invalid",
                               password: "foo",
                               password_confirmation: "bar" }
    end
    assert_template 'users/new'
  end

  test "User model valid" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, user: { name: "Example User",
                               email: "user@valid.com",
                               password: "foobar",
                               password_confirmation: "foobar" }
    end
    follow_redirect!
    assert_template 'users/show'
  end
end