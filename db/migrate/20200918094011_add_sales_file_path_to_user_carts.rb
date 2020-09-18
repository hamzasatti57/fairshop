class AddSalesFilePathToUserCarts < ActiveRecord::Migration[5.2]
  def change
    add_column :user_carts, :sales_file_path, :string
  end
end
