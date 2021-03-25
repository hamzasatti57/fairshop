class AddCategoryTagsToStores < ActiveRecord::Migration[5.2]
  def change
    add_column :stores, :category_tags, :string
    add_column :stores, :store_fax, :string
    add_column :stores, :lat, :string
    add_column :stores, :long, :string
    add_column :stores, :operating_hours, :string
    remove_column :stores, :store_on_time, :string
    remove_column :stores, :store_close_time, :string
  end
end
