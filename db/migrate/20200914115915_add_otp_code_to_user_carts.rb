class AddOtpCodeToUserCarts < ActiveRecord::Migration[5.2]
  def change
    add_column :user_carts, :otp_code, :string
    add_column :products, :stock_item_id, :string
    add_column :products, :stock_category_id, :string
    add_column :products, :stock_profile, :string
    add_column :products, :website_item, :boolean
    add_column :products, :website_listing_date, :datetime
    add_column :products, :website_expiry_date, :datetime
    add_column :products, :online_delivery_charges, :string
  end
end
