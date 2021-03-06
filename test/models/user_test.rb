require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # p_213
  # этот метод автоматически запускается перед каждым тестом
  def setup
    # p_232: добавление пароля и проверки
    @user = User.new(name: "Example User", email: "user@examle.com",
                     password: "foobar", password_confirmation: "foobar")
  end

  # проверка допустимости
  test "should be valid" do
    # метод assert: возврщает true - если получает true и false при обратном.
    assert @user.valid?
  end

  # проверка недопустимости имени из одних пробелов
  # проверка наличия осуществл. в app/models/user.rb
  test "name should be present" do
    @user.name = " "
    # обратное от assert, как = и !=
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.name = " "
    assert_not @user.valid?
  end

  test "name  should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  # тест правильных адресов, должен проходить
  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_addresses|
      @user.email = valid_addresses
      # p_219: если потерпит неудачу, то выводится второй аргумент
      # метод inspect возвращает литеральное представление
      assert @user.valid?, "#{valid_addresses.inspect} should be valid"
    end
  end

  # тест из неправильных адресов (форматов)
  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_addresses|
      @user.email = invalid_addresses
      assert_not @user.valid?, "#{invalid_addresses.inspect} should be  invalid"
    end
  end

  # тест уникальности (пользователь без повторов)
  test "email addresses should be unique" do
    # метод .dup создает дубликат
    duplicate_user = @user.dup
    # p_224: тестируем нечувствительность к ренистру проверки уникальности.
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "password should havea minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  # p_237: тест на проверку преобразования email в нижний регистр
  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAmpLe.coM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  # p_333: Проверка вызова authenticated? с несуществующим дайджестом
    # проверка теста с двумя браузерами: токен оставили пустым
  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?('')
  end

end
