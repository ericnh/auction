require 'test_helper'

class UserShowTest < ActionDispatch::IntegrationTest
  def setup
    @active_user = users(:bob)
    @inactive_user = users(:gary)
  end

  test "inactive users should not have show page" do
    log_in_as(@active_user)
    get user_path(@active_user)
    assert_template 'users/show'
    get user_path(@inactive_user)
    assert_redirected_to root_url
  end

end
