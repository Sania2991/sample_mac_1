require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

  # p_192-193
  test "layout links" do
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    get signup_path                                                              # p_199
    assert_select "title", full_title("Sign up")                                 # p_199
  end

end
