class CreatePaymentEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :payment_events do |t|
      t.references :payment, null: false, foreign_key: true
      t.jsonb :raw_data, null: false
      t.string :event_name, null: false

      t.timestamps
    end
  end
end
