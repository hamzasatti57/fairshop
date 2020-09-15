class UserCartProduct < ApplicationRecord
  belongs_to :user
  belongs_to :product
  belongs_to :user_cart
  belongs_to :color, optional: true
  validates_uniqueness_of :product, scope: [:user_id, :user_cart_id], message: "Already added to cart."

end
