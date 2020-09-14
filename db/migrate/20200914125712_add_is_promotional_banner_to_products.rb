class AddIsPromotionalBannerToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :is_promotional_banner, :boolean, default: false
  end
end
