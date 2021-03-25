class CreateJoinTableColorsProducts < ActiveRecord::Migration[5.2]
  def change
    create_join_table :colors, :products do |t|
      t.references :color, foreign_key: true
      t.references :product, foreign_key: true
    end
  end
end
