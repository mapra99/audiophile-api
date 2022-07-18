class CreatePurchaseCarts < ActiveRecord::Migration[6.1]
  def change
    create_table :purchase_carts do |t|
      t.string :status, null: false
      t.float :total_price, null: false
      t.string :uuid, null: false

      t.timestamps
    end

    add_index :purchase_carts, :uuid, unique: true
  end
end
