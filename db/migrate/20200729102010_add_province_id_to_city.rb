class AddProvinceIdToCity < ActiveRecord::Migration[5.2]
  def change
    add_column :cities, :province_id, :integer
    add_column :billing_addresses, :province_id, :integer
    add_column :checkouts, :user_id, :integer
  end
end
