require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  # p_365:
  def setup
    @user = users(:michael)
    # p_367: переменная класса второго пользовател
    @other_user = users(:archer)
  end


  # p_375: Тестирование переадресации в методе index незарегистр. польз.
  test "should redirect index when not logged in" do
    get users_path
    # p_375: проверяем переадресацию в методе index
    assert_redirected_to login_url
  end


  test "should get new" do
    get signup_path
    assert_response :success
  end

  # p_365: тестирование защищенности метода edit.
    # тестируем метод before_action в app/controllers/users_controller.rb
  # случай, когда незарег. пользов. редактирует
  test "should redirect edit when not logged in" do
    # Так в Rails 4.0
    # p_365: Соглашение Rails:   id: @user  =>  @user.id
    # get :edit, id: @user
    # , а так в 5.0
    # отправляется
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  # p_365: тестирование защищенности метода update
  # случай, когда незарег. пользов. обновляет свои данные
  test "should redirect update when not logged in" do
    # Так в Rails 4.0
    # p_365: Также соглашение Rails, но чтобы получить верные маршруты необход.
      # передать дополнительный хэш user.
    # patch :update, id: @user, user: { name: @user.name, email: @user.email }
    # , а так в 5.0
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end


  # p_367: попытка редактировать профиль другого пользователя
  test "should redirect edit when logged in as wrong user" do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end

  # p_367: попытка обновления профиля другого пользователя
  test "should redirect update when logged in as wrong user" do
    log_in_as(@other_user)
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert flash.empty?
    assert_redirected_to root_url
  end


end














