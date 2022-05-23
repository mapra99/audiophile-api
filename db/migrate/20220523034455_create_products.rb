class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.float :base_price, null: false
      t.boolean :featured, default: false

      t.timestamps
    end

    add_index :products, :slug, unique: true
    add_index :products, :featured
  end
end
