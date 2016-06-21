class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.string :name
      t.string :icon_path
      t.string :category
      t.belongs_to(:basket, index: true)
      t.timestamps
    end
  end
end
