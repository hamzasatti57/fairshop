class AddCleanAndCareToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :clean_and_care, :boolean
    add_column :products, :warranty, :boolean
    add_column :products, :sub_category_material, :string
    add_column :products, :code, :string
    add_column :products, :m2, :string
  end
end
 