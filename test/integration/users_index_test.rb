require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:bob)
  end

  test "index should be paginated" do
    log_in_as(@user)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination', count: 2
    User.paginate(page: 1).each do |user|
      if user.activated?
        assert_select 'a[href=?]', user_path(user), text: user.name
      else
        assert_select 'a[href=?]', user_path(user), text: user.name, count: 0
      end
    end
  end
end
