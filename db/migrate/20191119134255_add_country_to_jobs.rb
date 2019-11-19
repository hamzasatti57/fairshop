class AddCountryToJobs < ActiveRecord::Migration[5.2]
  def change
    add_reference :jobs, :country, foreign_key: true
  end
end
