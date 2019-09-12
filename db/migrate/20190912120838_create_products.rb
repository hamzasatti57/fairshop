class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :product_name
      t.string :product_category
      t.string :product_brand
      t.string :product_model
      t.string :product_warranty
      t.string :product_color
      t.boolean :product_isview
      t.boolean :product_sale_status
      t.integer :product_purchase_price
      t.integer :product_sale_price
      t.boolean :product_cash_on_delivery
      t.boolean :product_home_delivery
      t.integer :product_return_days
      t.integer :product_discount
      t.string :product_material
      t.integer :product_quantity
      t.references :store, foreign_key: true

      t.timestamps
    end
  end
end
