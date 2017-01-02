class AddIndexToUsersEmail < ActiveRecord::Migration[5.0]
  def change
    # p_227: добавление уникальности к email с помощью параметра unique: true
    add_index :users, :email, unique: true
  end
end
