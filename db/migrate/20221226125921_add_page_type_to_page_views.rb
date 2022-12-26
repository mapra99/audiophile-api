class AddPageTypeToPageViews < ActiveRecord::Migration[6.1]
  def change
    add_column :page_views, :page_type, :string
    add_index :page_views, :page_type
  end
end
