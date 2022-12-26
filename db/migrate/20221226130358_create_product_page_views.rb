class CreateProductPageViews < ActiveRecord::Migration[6.1]
  def change
    create_table :product_page_views do |t|
      t.references :product, null: false, foreign_key: true
      t.references :page_view, null: false, foreign_key: true

      t.timestamps
    end
  end
end
