class RemoveCountryFromJobs < ActiveRecord::Migration[5.2]
  def change
    remove_column :jobs, :country
  end
end
