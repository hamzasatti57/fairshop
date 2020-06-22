class CreateSuperCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :super_categories do |t|
      t.string :title

      t.timestamps
    end
  end
end
