class AddAdminToUsers < ActiveRecord::Migration[5.0]

  # p_388: Миграция для добавления логического атрибута admin в модель User.1
  def change
    add_column :users, :admin, :boolean, default: false
  end
end
