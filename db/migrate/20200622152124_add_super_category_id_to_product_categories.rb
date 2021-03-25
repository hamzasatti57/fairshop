class AddSuperCategoryIdToProductCategories < ActiveRecord::Migration[5.2]
  def change
    add_column :product_categories, :super_category_id, :integer
  end
end
