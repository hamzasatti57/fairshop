class CreateUserCartProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :user_cart_products do |t|
      t.integer :user_id
      t.integer :product_id
      t.integer :quantity
      t.float :sub_total

      t.timestamps
    end
  end
end
