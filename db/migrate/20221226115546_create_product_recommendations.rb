class CreateProductRecommendations < ActiveRecord::Migration[6.1]
  def change
    create_table :product_recommendations do |t|
      t.references :product, null: false, foreign_key: true
      t.references :recommendation, null: false, foreign_key: { to_table: :products }

      t.timestamps
    end
  end
end
