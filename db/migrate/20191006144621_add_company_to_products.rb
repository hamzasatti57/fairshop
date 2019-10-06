class AddCompanyToProducts < ActiveRecord::Migration[5.2]
  def change
    add_reference :products, :company, foreign_key: true
  end
end
