class CreateCheckouts < ActiveRecord::Migration[5.2]
  def change
    create_table :checkouts do |t|
      t.integer :billing_address_id

      t.timestamps
    end
  end
end
