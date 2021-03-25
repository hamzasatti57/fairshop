class AddFullNameToComments < ActiveRecord::Migration[5.2]
  def change
    add_column :comments, :commentor_full_name, :string
    add_column :comments, :commentor_email_address, :string
    add_column :comments, :commentor_phone_number, :string
  end
end
