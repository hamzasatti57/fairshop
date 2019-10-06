class CreateCompanies < ActiveRecord::Migration[5.2]
  def change
    create_table :companies do |t|
      t.string :title
      t.string :address
      t.string :contact
      t.string :individual_experience

      t.timestamps
    end
  end
end
