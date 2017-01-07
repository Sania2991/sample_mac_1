require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest

  def setup
    # поменяли вместо user на админ и не админ.
    @admin = users(:michael)
    # p_394: не администратор
    @non_admin = users(:archer)
  end

  # p_385: тест для списка пользователей и постраничного просмотра для admin
  test "index including pagination" do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    # тест проверяет наличие тега div с классом pagination
    assert_select 'div.pagination'
    # а также наличие первой страницы списка пользователей
    # p_394: для удобства ввели переменную:
    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      # если user не admin => должна быть ссылка и метод delete
      unless user == @admin
        assert_select 'a[href=?]', user_path(user), text: 'delete',
                                                    method: :delete
        end
    end
    # p_393: т.к. ссылки для удаления находятся на стр. списка польз - тесты тут
    # p_393: проверяем факт удаления польз. после щелчка по ссылке.
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
  end

  # p_394: тест для не admin
  test "index as non-admin" do
    log_in_as(@non_admin)
    get users_path
    # проверяет отсутствие ссылок на странице у не admin
    assert_select 'a', text: 'delete', count: 0
  end

end
