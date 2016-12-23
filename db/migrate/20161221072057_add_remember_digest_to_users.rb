class AddRememberDigestToUsers < ActiveRecord::Migration[5.0]
  def change
    # p_319: т.к. мы не собираемся извлекатьданные о пользователях по этому
      # атрибуту, нет необходимости добавлять индекс для столбца remember_digest
    add_column :users, :remember_digest, :string
  end
end
