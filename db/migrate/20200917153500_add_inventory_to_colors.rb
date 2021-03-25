class AddInventoryToColors < ActiveRecord::Migration[5.2]
  def change
    add_column :colors, :inventory, :integer
  end
end
