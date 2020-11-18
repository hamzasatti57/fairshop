class ChangeDefaultValueOfInventoryInProductColors < ActiveRecord::Migration[5.2]
  def change
    change_column :product_colors, :inventory, :integer, default: 0
    change_column :products, :inventory, :integer, default: 0
  end
end
