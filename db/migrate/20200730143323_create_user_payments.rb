class CreateUserPayments < ActiveRecord::Migration[5.2]
  def change
    create_table :user_payments do |t|
      t.integer :user_id
      t.float :amount

      t.timestamps
    end
  end
end
