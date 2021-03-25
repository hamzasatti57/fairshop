class CreateProvinces < ActiveRecord::Migration[5.2]
  def change
    create_table :provinces do |t|
      t.integer :country_id

      t.timestamps
    end
  end
end
