class AddUuidToStocks < ActiveRecord::Migration[6.1]
  def change
    add_column :stocks, :uuid, :string, null: false
    add_index :stocks, [:uuid], unique: true
  end
end
