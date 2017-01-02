require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  # p_272: тест провальной регистрации
  test "invalid signup information" do
    # посещаем страницу регистрации
    get signup_path
    # сравниваем User.count до и после выполнения блока
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name: "",
                               email: "user@invalid",
                               password: "foo",
                               password_confirmation: "bar" } }
    end
    # проверка повторного обращения к методу new при ошибочной регистрации.
    assert_template 'users/new'
  end


  # p_280: тест успешной регистрации
  test "valid signup information" do
    get signup_path
    # assert_difference - сравнение, 2-ой арг. (необязат.) - РАЗНИЦА!
    # //
    # assert_difference 'User.count', 1 do
    #   # post_via_redirect - передача post запроса маршруту: users_path
    #   post_via_redirect users_path, user: { name:  "Example User",
    #                                         email: "user@example.com",
    #                                         password:              "password",
    #                                         password_confirmation: "password"}
    # end
    # была произведена замена, т.к. post запросы имеют теперь другой формат:
    assert_difference 'User.count', 1 do
      # post_via_redirect - передача post запроса маршруту: users_path
      post users_path, params: { user: { name:  "Example User",
                                            email: "user@example.com",
                                            password:              "password",
                                            password_confirmation: "password"} }
    end
    # переход по этой странице
    follow_redirect!
    # --//

    assert_template 'users/show'
    # p_315: тест входа после регистрации (метод прописан в test/test_helper.rb)
    assert is_logged_in?
  end

end
