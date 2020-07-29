class Checkout < ApplicationRecord
  belongs_to :billing_address
  belongs_to :user

end
