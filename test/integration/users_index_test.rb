require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest

def setup
  @user = users(:michael)
end

# p_385: тест для списка пользователей и постраничного просмотра
test "index including pagination" do
  log_in_as(@user)
  get users_path
  assert_template 'users/index'
  # тест проверяет наличие тега div с классом pagination
  assert_select 'div.pagination'
  # а также наличие первой страницы списка пользователей
  User.paginate(page: 1).each do |user|
    assert_select 'a[href=?]', user_path(user), text: user.name
  end

end

end
