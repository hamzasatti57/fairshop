class CreateStores < ActiveRecord::Migration[5.2]
  def change
    create_table :stores do |t|
      t.string :store_name
      t.string :store_city
      t.string :store_address
      t.string :store_city
      t.string :store_country
      t.string :store_state
      t.string :store_area
      t.string :store_map_link
      t.boolean :stroe_active
      t.time :store_on_time
      t.time :store_close_time
      t.references :vender, foreign_key: true

      t.timestamps
    end
  end
end
