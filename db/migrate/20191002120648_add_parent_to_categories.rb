class AddParentToCategories < ActiveRecord::Migration[5.2]
  def change
    add_column :categories, :parent_id, :integer, null: true, index: true
    add_foreign_key :categories, :categories, column: :parent_id
  end
end
