class CreateLocations < ActiveRecord::Migration[6.1]
  def change
    create_table :locations do |t|
      t.string :street_address, null: false
      t.string :postal_code, null: false
      t.string :city, null: false
      t.string :country, null: false
      t.string :longitude
      t.string :latitude
      t.string :external_id

      t.timestamps
    end

    add_index :locations, :external_id, unique: true
  end
end
