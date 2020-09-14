class Color < ApplicationRecord
  has_and_belongs_to_many :products
  has_many :user_cart_products
end
