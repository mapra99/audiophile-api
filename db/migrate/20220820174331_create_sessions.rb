class CreateSessions < ActiveRecord::Migration[6.1]
  def change
    create_table :sessions do |t|
      t.string :uuid, null: false
      t.string :ip_address, null: false

      t.timestamps
    end

    add_index :sessions, :uuid, unique: true
  end
end
