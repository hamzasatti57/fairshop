class CreateProductColors < ActiveRecord::Migration[5.2]
  def change
    create_table :product_colors do |t|
      t.integer :color_id
      t.integer :product_id
      t.string :stock_item_id
      t.integer :inventory

      t.timestamps
    end
  end
end
