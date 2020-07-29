class BillingAddress < ApplicationRecord

  has_many :checkout
  belongs_to :user
  belongs_to :country
  belongs_to :province
  belongs_to :city
end
