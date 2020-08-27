class CreatePeachPayments < ActiveRecord::Migration[5.2]
  def change
    create_table :peach_payments do |t|
      t.string :card_number
      t.string :expiry_date
      t.string :card_holder
      t.string :cvv
      t.float :amount
      t.string :checkout_id
      t.integer :user_id

      t.timestamps
    end
  end
end
