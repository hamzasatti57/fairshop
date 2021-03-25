class AddTitleToProvinces < ActiveRecord::Migration[5.2]
  def change
    add_column :provinces, :title, :string
  end
end
