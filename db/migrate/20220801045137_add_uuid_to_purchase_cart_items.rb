class AddUuidToPurchaseCartItems < ActiveRecord::Migration[6.1]
  def change
    add_column :purchase_cart_items, :uuid, :string, null: false
    add_index :purchase_cart_items, :uuid, unique: true
  end
end
