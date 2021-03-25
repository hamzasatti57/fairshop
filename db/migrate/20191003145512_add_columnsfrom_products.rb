class AddColumnsfromProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :inventory, :integer
    add_column :products, :price, :float
    add_column :products, :length, :float
    add_column :products, :width, :float
    add_column :products, :height, :float
    add_column :products, :status, :boolean
    add_column :products, :visibility, :boolean
  end
end
