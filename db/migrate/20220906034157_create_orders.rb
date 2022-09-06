class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.references :payment, null: false, foreign_key: true
      t.references :user_location, null: false, foreign_key: true
      t.string :status, null: false

      t.timestamps
    end
  end
end
