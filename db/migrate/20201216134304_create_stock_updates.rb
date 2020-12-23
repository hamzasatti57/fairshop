class CreateStockUpdates < ActiveRecord::Migration[5.2]
  def change
    create_table :stock_updates do |t|
      t.datetime :stock_file
      t.datetime :gp_stock_file

      t.timestamps
    end
  end
end
