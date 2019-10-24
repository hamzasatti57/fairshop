class AddUserToAdvertisements < ActiveRecord::Migration[5.2]
  def change
    add_reference :advertisements, :user, foreign_key: true
  end
end
