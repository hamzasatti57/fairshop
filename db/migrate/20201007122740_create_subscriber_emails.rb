class CreateSubscriberEmails < ActiveRecord::Migration[5.2]
  def change
    create_table :subscriber_emails do |t|
      t.string :email
      t.boolean :is_active, default: true

      t.timestamps
    end
  end
end
