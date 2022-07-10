class CreateStockToppings < ActiveRecord::Migration[6.1]
  def change
    create_table :stock_toppings do |t|
      t.references :topping, null: false, foreign_key: true
      t.references :stock, null: false, foreign_key: true

      t.timestamps
    end

    add_index :stock_toppings, %i[topping_id stock_id], unique: true
  end
end
