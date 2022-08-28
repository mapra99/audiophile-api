class CreateUserLocations < ActiveRecord::Migration[6.1]
  def change
    create_table :user_locations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :location, null: false, foreign_key: true
      t.string :extra_info
      t.string :uuid, null: false

      t.timestamps
    end

    add_index :user_locations, :uuid, unique: true
  end
end
