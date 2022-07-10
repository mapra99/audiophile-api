class CreateToppings < ActiveRecord::Migration[6.1]
  def change
    create_table :toppings do |t|
      t.references :product, null: false, foreign_key: true
      t.string :key, null: false
      t.string :value, null: false
      t.string :price_change

      t.timestamps
    end

    add_index :toppings, :key
    add_index :toppings, %i[key value product_id], unique: true
  end
end
