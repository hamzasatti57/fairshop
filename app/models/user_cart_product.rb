class UserCartProduct < ApplicationRecord
  belongs_to :user
  belongs_to :product
  validates_uniqueness_of :product, scope: :user_id, message: "Already added to cart."

end
