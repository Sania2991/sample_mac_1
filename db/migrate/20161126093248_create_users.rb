# р_204
class CreateUsers < ActiveRecord::Migration[5.0]
  # Метод определяет изменение в БД
  def change
    # Метод create_table принимает блок
    create_table :users do |t|
      # создаются столбцы
      t.string :name
      t.string :email
      # это команда создает 2 столбца:create_at и apdate_at
      t.timestamps
    end
  end
end
