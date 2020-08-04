class UserCart < ApplicationRecord
  belongs_to :user
  has_one :checkout
  has_many :user_cart_products
  enum status: {pending: 0, in_progress: 1, paid: 2}
end
