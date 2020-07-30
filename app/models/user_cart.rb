class UserCart < ApplicationRecord
  belongs_to :user
  has_one :checkout
  has_many :user_cart_products
end
