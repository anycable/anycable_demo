class CreateBaskets < ActiveRecord::Migration[5.0]
  def change
    create_table :baskets do |t|
      t.string :name
      t.string :logo_path
      t.string :owner
      t.text :description
      t.integer :items_count, null: false, default: 0
      t.timestamps
    end
  end
end
