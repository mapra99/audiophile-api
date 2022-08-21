class AddSessionIdToPurchaseCarts < ActiveRecord::Migration[6.1]
  def change
    add_reference :purchase_carts, :session, foreign_key: true
  end
end
