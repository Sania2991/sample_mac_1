require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

    def setup
        @user = users(:michael)
    end

  # p_299: тест выявляющий ошибку хэша flash
  test "login with invalid information" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: "", password: "" } }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end


  # p_312: тест входа пользователя с верной информацией
  test "login with valid information followed by logout" do
    get login_path
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } }
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
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end

  # p_342: Тест флажка "Запомни меня" - 1
  test "login with remembering" do
    log_in_as(@user, remember_me: '1')
    assert_not_empty cookies['remember_token']

    # p_349: упражнение!!! assign - позволяет получ. доступ к .remember_token
    # НО НУЖНО ПЕРЕНАЗНАЧИТЬ ПЕРЕМЕННУЮ USER в create
    # assert_equal assigns(:user).remember_token, not_empty
  end

  # p_342: Тест флажка "Запомни меня" - 0
  test "login without remember_me" do
    # Log in to set the cookie.
    #debugger
    log_in_as(@user, remember_me: '1')
    # Log in again and verify that the cookie is deleted.
    log_in_as(@user, remember_me: '0')
    assert_empty cookies['remember_token']

#    log_in_as(@user, remember_me: '0')
#   assert_empty cookies['remember_token']
  end

end
