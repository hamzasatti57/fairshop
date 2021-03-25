class CreateContacts < ActiveRecord::Migration[5.2]
  def change
    create_table :contacts do |t|
      t.string :message
      t.string :name
      t.string :email
      t.string :subject

      t.timestamps
    end
  end
end
