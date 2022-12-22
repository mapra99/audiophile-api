class CreatePageViews < ActiveRecord::Migration[6.1]
  def change
    create_table :page_views do |t|
      t.references :session, null: false, foreign_key: true
      t.string :page_path, null: false
      t.string :query_params

      t.timestamps
    end

    add_index :page_views, :page_path
  end
end
