class CreatePurchaseCartItems < ActiveRecord::Migration[6.1]
  def change
    create_table :purchase_cart_items do |t|
      t.references :purchase_cart, null: false, foreign_key: true
      t.references :stock, null: false, foreign_key: true
      t.integer :quantity, null: false
      t.float :unit_price, null: false

      t.timestamps
    end
  end
end
