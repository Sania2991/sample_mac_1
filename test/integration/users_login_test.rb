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
    post login_path, params: { session: { email: "", password: "" } }
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
  # test "login with valid information" do
  # p_317: имя теста и функционал был немного изменён:
  test "login with valid information followed by logout" do
    get login_path
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } }
    # p_317: тест входа после регистрации (метод прописан в test/test_helper.rb)
    assert is_logged_in?
    # p_312: Проеряем переадресацию
    assert_redirected_to @user
    # p_312: используем, чтобы открыть эту страницу
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    # p_317: дальше идут те самые изменения:
    # отправляем запрос delete
    delete logout_path
    # убеждаемся, что пользователь вышел
    assert_not is_logged_in?
    # проверяем переадресацию
    assert_redirected_to root_url
    # p_332: Сымитировать щелчок на ссылке для выхода на втором окне.
    delete logout_path
    # прозодим по ней
    follow_redirect!
    # проверяем, что появилась ссылка на вход
    assert_select "a[href=?]", login_path
    # а ссылки на выход пропала
    assert_select "a[href=?]", logout_path, count: 0
    # а также ссылка на профиль
    assert_select "a[href=?]", user_path(@user), count: 0
  end

  # p_342: Тест флажка "Запомни меня" - 1
  # тестовые данные в test/fixtures/users.yml, переменная определена выше
  test "login with remembering" do
    log_in_as(@user, remember_me: '1')
    assert_not_nil cookies['remember_token']
  end

  # p_342: Тест флажка "Запомни меня" - 0
  test "login without remember_me" do
    log_in_as(@user, remember_me: '0')
    assert_nil cookies['remember_token']
  end

end
