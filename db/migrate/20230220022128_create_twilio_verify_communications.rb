class CreateTwilioVerifyCommunications < ActiveRecord::Migration[6.1]
  def change
    create_table :twilio_verify_communications do |t|
      t.string :recipient, null: false
      t.string :verification_sid, null: false
      t.string :channel, null: false
      t.string :service_sid, null: false
      t.references :communication, null: false, foreign_key: true
      t.references :target, polymorphic: true

      t.timestamps
    end
  end
end
