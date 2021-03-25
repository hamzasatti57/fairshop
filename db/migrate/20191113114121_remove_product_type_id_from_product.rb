class RemoveProductTypeIdFromProduct < ActiveRecord::Migration[5.2]
  def change
    remove_reference :products, :product_type, index: true, foreign_key: true
  end
end
