class AddPrintDescriptionToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :print_description, :string
  end
end
