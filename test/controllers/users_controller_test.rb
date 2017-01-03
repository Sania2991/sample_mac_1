require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  # p_365:
  def setup
    @user = users(:michael)
  end

  test "should get new" do
    get signup_path
    assert_response :success
  end

  # p_365: тестирование защищенности метода edit.
    # Метод before_action в app/controllers/users_controller.rb
  test "should redirect edit when not logged in" do
    # Так в Rails 4.0
    # p_365: Соглашение Rails:   id: @user  =>  @user.id
    # get :edit, id: @user
    # , а так в 5.0
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  # p_365: тестирование защищенности метода update
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


end
