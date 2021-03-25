class AddIsDiscountedToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :is_discounted, :boolean, default: false
  end
end
