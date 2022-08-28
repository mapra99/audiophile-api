class CreateLocations < ActiveRecord::Migration[6.1]
  def change
    create_table :locations do |t|
      t.string :street_address, null: false
      t.string :postal_code, null: false
      t.string :city, null: false
      t.string :country, null: false
      t.decimal :longitude
      t.decimal :latitude
      t.jsonb :raw_geocode

      t.timestamps
    end

    add_index :locations, %i[longitude latitude], unique: true
  end
end
