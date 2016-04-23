require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase
  test "should get home" do
    get :home
    assert_response :success
    assert_select "title", "Home | Guatemala Silent Auction"
  end

  test "should get about" do
    get :about
    assert_response :success
    assert_select "title", "About | Guatemala Silent Auction"
  end

  test "should get donate" do
    get :donate
    assert_response :success
    assert_select "title", "Donate | Guatemala Silent Auction"
  end

end
