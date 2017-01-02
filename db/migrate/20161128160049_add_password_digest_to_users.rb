class AddPasswordDigestToUsers < ActiveRecord::Migration[5.0]
  def change
    # p_230: добавление в табл. users столбца password_digest
    add_column :users, :password_digest, :string
  end
end
