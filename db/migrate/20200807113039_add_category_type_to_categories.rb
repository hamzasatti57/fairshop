class AddCategoryTypeToCategories < ActiveRecord::Migration[5.2]
  def change
    add_column :categories, :category_type, :integer, default: 1
  end
end
