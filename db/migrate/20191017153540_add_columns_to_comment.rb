class AddColumnsToComment < ActiveRecord::Migration[5.2]
  def change
    add_column :comments, :parent_id, :integer
    add_column :comments, :parent_type, :integer
    add_column :comments, :statement, :string
  end
end
