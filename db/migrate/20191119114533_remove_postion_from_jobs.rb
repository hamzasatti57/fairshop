class RemovePostionFromJobs < ActiveRecord::Migration[5.2]
  def change
    remove_column :jobs, :position
  end
end
