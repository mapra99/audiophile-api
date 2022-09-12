class AddUserLocationToPurchaseCarts < ActiveRecord::Migration[6.1]
  def change
    add_reference :purchase_carts, :user_location, null: true, foreign_key: true
  end
end
