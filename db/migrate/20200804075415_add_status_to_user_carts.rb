class AddStatusToUserCarts < ActiveRecord::Migration[5.2]
  def change
    add_column :user_carts, :status, :integer, default: 0
  end
end
