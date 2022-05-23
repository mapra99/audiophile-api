class CreateProductContents < ActiveRecord::Migration[6.1]
  def change
    create_table :product_contents do |t|
      t.string :key, null: false
      t.text :value
      t.references :product, null: false, foreign_key: true

      t.timestamps
    end

    add_index :product_contents, :key
    add_index :product_contents, %i[key product_id], unique: true
  end
end
