require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  # p_424: тестирование активации учетной записи
  def setup
    ActionMailer::Base.deliveries.clear
  end

  # p_272: тест провальной регистрации
  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name: "",
                               email: "user@invalid",
                               password: "foo",
                               password_confirmation: "bar" } }
    end
    assert_template 'users/new'
  end


  # p_280: тест успешной регистрации
  # p_424: дополнили тестированием активации
  test "valid signup information with account activation" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name:  "Example User",
                                         email: "user@example.com",
                                         password:              "password",
                                         password_confirmation: "password" } }
    end
    # p_425: дополнили след. кодом:
    # p_425: проверяет, чтобы было доставлено точно одно письмо!
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?
    # p_425: попытиаться выполнить вход до активации:
    log_in_as(user)
    # проверяем вошел ли тестовый пользователь
    assert_not is_logged_in?
    # p_425: недопустимый токен активации
    get edit_account_activation_path("invali token", email: user.email)
    assert_not is_logged_in?
    # p_425: Допустимый токен, неверный адрес электронной почты
    get edit_account_activation_path(user.activation_token, email: 'wrong')
    assert_not is_logged_in?
    # p_425: допустимый токен
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    # p_415: временно закомментируем, т.к. сейчас нас перенаправл. на гл. стр.
    # p_425: раскоментируем
    assert_template 'users/show'
    assert is_logged_in?
  end

end













