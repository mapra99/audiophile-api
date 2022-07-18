class CreatePurchaseCartExtraFees < ActiveRecord::Migration[6.1]
  def change
    create_table :purchase_cart_extra_fees do |t|
      t.references :purchase_cart, null: false, foreign_key: true
      t.string :key, null: false
      t.float :price, null: false

      t.timestamps
    end

    add_index :purchase_cart_extra_fees, :key
    add_index :purchase_cart_extra_fees, %i[key purchase_cart_id], unique: true
  end
end
