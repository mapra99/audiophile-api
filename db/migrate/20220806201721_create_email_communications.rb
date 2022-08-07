class CreateEmailCommunications < ActiveRecord::Migration[6.1]
  def change
    create_table :email_communications do |t|
      t.string :sender, null: false
      t.string :recipient, null: false
      t.string :subject, null: false
      t.string :template_id, null: false
      t.json :template_data
      t.references :communication, null: false, foreign_key: true
      t.references :target, polymorphic: true

      t.timestamps
    end
  end
end
