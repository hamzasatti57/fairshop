class AddProductTypeIdToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :product_type_id, :integer
  end
end
