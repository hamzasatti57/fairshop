class RemoveCompanyFromJobs < ActiveRecord::Migration[5.2]
  def change
    remove_column :jobs, :company
  end
end
