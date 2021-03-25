class RemoveContactDetailsfromProfile < ActiveRecord::Migration[5.2]
  def change
    remove_column :profiles, :contact_detail
  end
end
