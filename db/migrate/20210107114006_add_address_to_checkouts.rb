class AddAddressToCheckouts < ActiveRecord::Migration[5.2]
  def change
    add_column :checkouts, :address, :string
  end
end
