class DropColorsProducts < ActiveRecord::Migration[5.2]
  def change
    drop_table :colors_products
  end
end
