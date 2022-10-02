class AddUuidToOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :uuid, :string, null: false
    add_index :orders, :uuid, :unique => true
  end
end
