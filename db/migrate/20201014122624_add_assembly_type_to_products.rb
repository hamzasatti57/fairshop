class AddAssemblyTypeToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :assembly_type, :integer
  end
end
