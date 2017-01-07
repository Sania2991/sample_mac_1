require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  # p_357: неудачная попытка редактирования
  test "unsuccessful edit" do
    # p_364: осуществляем вход пользователя до вызова метода edit и update
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), user: { name: '',
                                    email: 'foo@invalid',
                                    password:              'foo',
                                    password_confirmation: 'bar' }
    assert_template 'users/edit'
  end


  # p_359: тест успешной попытки редактирования
  # p_371: изменили тест: тест дружелюбной переадресации (куда надо было)
  test "successful edit with friendly forwarding" do
    # p_371: пытаемся посетить страницу редактирования (еще незарегистрирован)
    get edit_user_path(@user)
    # p_397: проверяем, что session[:forwarding_url] запомнил наш путь
    assert_equal session[:forwarding_url], edit_user_url(@user)
    # p_364: осуществляем вход пользователя до вызова метода edit и update
    log_in_as(@user)
    assert_redirected_to edit_user_url(@user)
    # -p_371: get edit_user_path(@user)
    # -p_371: assert_template 'users/edit'  # т.к. ожидается другая переадр.
    name  = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), user: { name: name,
                                    email: email,
                                    password:             "",
                                    pasword_confirmation: "" }
    assert_not flash.empty?
    assert_redirected_to @user
    # обновим данные в Б.Д.
    @user.reload
    # сравним эти обновленные данные
    assert_equal @user.name, name
    assert_equal @user.email, email
    # p_397: проверяем друж. перенаправление на единственный раз
      # при повторном - по умолчанию., т.к. уже были переадресованны,
      # значит проверяем, что session[:forwarding_url] == nill
    assert_nil session[:forwarding_url]
  end

end
