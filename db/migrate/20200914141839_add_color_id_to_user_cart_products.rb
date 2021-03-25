class AddColorIdToUserCartProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :user_cart_products, :color_id, :integer
  end
end
