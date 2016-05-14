require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  test "home layout links" do
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", about_path, count: 2
    assert_select "a[href=?]", contact_path
    assert_select "a[href=?]", donate_path
    assert_select "a[href=?]", signup_path
  end

  test "about layout links" do
    get about_path
    assert_template 'static_pages/about'
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", about_path, count: 2
    assert_select "a[href=?]", contact_path
    assert_select "a[href=?]", donate_path
  end

  test "contact layout links" do
    get contact_path
    assert_template 'static_pages/contact'
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", about_path, count: 2
    assert_select "a[href=?]", contact_path
    assert_select "a[href=?]", donate_path
  end

  test "donate layout links" do
    get donate_path
    assert_template 'static_pages/donate'
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", about_path, count: 2
    assert_select "a[href=?]", contact_path
    assert_select "a[href=?]", donate_path
  end

  test "signup layout links" do
    get signup_path
    assert_template 'users/new'
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", about_path, count: 2
    assert_select "a[href=?]", contact_path
    assert_select "a[href=?]", donate_path
  end
end

