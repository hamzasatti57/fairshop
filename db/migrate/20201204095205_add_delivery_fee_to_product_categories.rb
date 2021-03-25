class AddDeliveryFeeToProductCategories < ActiveRecord::Migration[5.2]
  def change
    add_column :product_categories, :delivery_fee, :float, default: 0.0
  end
end
