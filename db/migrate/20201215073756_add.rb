class Add < ActiveRecord::Migration[5.2]
  def change
    add_column :product_categories, :stock_category_id, :string
  end
end
