class CreatePayments < ActiveRecord::Migration[6.1]
  def change
    create_table :payments do |t|
      t.string :uuid, null: false
      t.string :status, null: false
      t.float :amount, null: false
      t.string :provider_id, null: false
      t.references :purchase_cart, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
