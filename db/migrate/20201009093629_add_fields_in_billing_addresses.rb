class AddFieldsInBillingAddresses < ActiveRecord::Migration[5.2]
  def change
    add_column :billing_addresses, :street, :string
    add_column :billing_addresses, :house_no, :string
    add_column :billing_addresses, :suburb, :string
    add_column :billing_addresses, :unit_no, :string
    add_column :billing_addresses, :landmark, :string
    add_column :billing_addresses, :complex, :string
    add_column :billing_addresses, :secondary_number, :string
  end
end
