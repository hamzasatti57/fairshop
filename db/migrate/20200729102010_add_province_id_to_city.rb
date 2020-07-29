class AddProvinceIdToCity < ActiveRecord::Migration[5.2]
  def change
    add_column :cities, :province_id, :integer
    add_column :billing_addresses, :province_id, :integer
    add_column :checkouts, :user_id, :integer
    add_column :checkouts, :user_cart_id, :integer
    add_column :user_cart_products, :user_cart_id, :integer
    add_column :checkouts, :amount, :float
  end
end
