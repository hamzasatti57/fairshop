class CreateRatings < ActiveRecord::Migration[5.2]
  def change
    create_table :ratings do |t|
      t.decimal :value
      t.integer :parent_id
      t.integer :parent_type
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
