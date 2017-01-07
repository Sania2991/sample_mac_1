require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

  def setup
      @admin = users(:michael)
      @non_admin = users(:archer)
  end

  test "layout links" do
    get root_path
    # проверяем, что были переадресованы по правильному адресу
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    get signup_path
    assert_select "title", full_title("Sign up")
  end


  # p_397 (упр. 2): будем посещать все ссылки и сравнивать с тем, что должно
  # тест ссылок для незарегистр. пользователя
  test "layout links to not logged user" do
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", signup_path
    assert_select "a[href=?]", contact_path
  end

  # тест ссылок для зарегистрированного не админа

  # тест ссылок для админа

end
