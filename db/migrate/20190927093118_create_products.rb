class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :title
      t.string :description
      t.string :size
      t.string :price
      t.boolean :stock

      t.timestamps
    end
  end
end
