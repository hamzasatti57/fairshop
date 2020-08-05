class AddShippingPriceToCategories < ActiveRecord::Migration[5.2]
  def change
    add_column :categories, :shipping_price, :float
  end
end
