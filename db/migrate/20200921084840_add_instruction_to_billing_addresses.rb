class AddInstructionToBillingAddresses < ActiveRecord::Migration[5.2]
  def change
    add_column :billing_addresses, :instruction, :string
    add_column :billing_addresses, :latitude, :string
    add_column :billing_addresses, :longitude, :string
  end
end
