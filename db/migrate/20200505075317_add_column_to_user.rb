class AddColumnToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :AAA, :boolean, default: false
  end
end
