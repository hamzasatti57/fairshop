class AddStockItemIdToColors < ActiveRecord::Migration[5.2]
  def change
    add_column :colors, :stock_item_id, :string
  end
end
