require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

    # p_312: обращаемся к созд. пользователю в тестах: text/fixtures/users.yml
    def setup
        @user = users(:michael)
    end

  # p_299: тест выявляющий ошибку хэша flash
  test "login with invalid information" do
    # открыть страницу входа
    get login_path
    # убедиться, что форма, предоставляющая новый сеанс, отображается верно
    assert_template 'sessions/new'
    # отправить хэш params с ошибочной информацией в составе запроса по маршруту
    post login_path, session: { email: "", password: "" }
    # убедиться, что сервер вновь вернул форму,
    assert_template 'sessions/new'
    # , но уже с сообщением об ошибке
    assert_not flash.empty?
    # перейти на другую страницу (например на главную)
    get root_path
    # убедиться, что сообщение отсутствует на ней
    assert flash.empty?
  end

  # p_312: тест входа пользователя с верной информацией
  # @user - смотри метод setup - выше
  test "login with valid information" do
    get login_path
    post login_path, session: { email: @user.email, password: 'password' }
    # p_312: Проеряем переадресацию
    assert_redirected_to @user
    # p_312: исползуем, чтобы открыть эту страницу
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
  end

end
