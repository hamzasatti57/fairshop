class CreateStores < ActiveRecord::Migration[5.2]
  def change
    create_table :stores do |t|
      t.string :store_name
      t.string :store_address
      t.string :store_city
      t.string :store_country
      t.string :store_state
      t.string :store_zip
      t.string :store_phone
      t.string :store_email
      t.string :store_website
      t.string :store_link
      t.string :stroe_description
      t.string :store_on_time
      t.string :store_close_time
      t.integer :vender_id

      t.timestamps
    end
  end
end
