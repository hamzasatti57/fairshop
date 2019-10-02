class CreateProfiles < ActiveRecord::Migration[5.2]
  def change
    create_table :profiles do |t|
      t.string :facebook
      t.string :instagram
      t.string :twitter
      t.integer :gender
      t.date :dob
      t.string :contact_detail
      t.string :description

      t.timestamps
    end
  end
end
