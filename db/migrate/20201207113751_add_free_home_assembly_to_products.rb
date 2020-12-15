class AddFreeHomeAssemblyToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :free_home_assembly, :boolean, default: false
  end
end
