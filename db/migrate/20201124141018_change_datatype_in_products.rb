class ChangeDatatypeInProducts < ActiveRecord::Migration[5.2]
  def change
    change_column(:products, :warranty, :string)
    change_column(:products, :clean_and_care, :string)
  end
end
