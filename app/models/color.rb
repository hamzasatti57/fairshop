class Color < ApplicationRecord
  has_one_attached :image
  # has_and_belongs_to_many :products
  has_many :product_colors, dependent: :destroy
  has_many :products, through: :product_colors
  has_many :user_cart_products
end
