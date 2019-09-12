class CreateVenders < ActiveRecord::Migration[5.2]
  def change
    create_table :venders do |t|
      t.string :name
      t.string :email
      t.string :city
      t.string :address
      t.string :gender
      t.date :dob
      t.string :cnic
      t.string :contact
      t.string :country

      t.timestamps
    end
  end
end
