class CreateLikes < ActiveRecord::Migration[5.2]
  def change
    create_table :likes do |t|
      t.boolean :value
      t.integer :parent_id
      t.integer :parent_type
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
