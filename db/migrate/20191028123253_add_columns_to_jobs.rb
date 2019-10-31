class AddColumnsToJobs < ActiveRecord::Migration[5.2]
  def change
    add_column :jobs, :company, :string
    add_column :jobs, :position, :string
    add_column :jobs, :country, :string
  end
end
