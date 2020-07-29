class CreateBillingAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :billing_addresses do |t|
      t.string :address
      t.string :postal_code
      t.integer :user_id
      t.integer :city_id
      t.integer :country_id
      t.boolean :is_primary

      t.timestamps
    end
  end
end
