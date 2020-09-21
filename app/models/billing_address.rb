class BillingAddress < ApplicationRecord

  has_many :checkout
  belongs_to :user
  belongs_to :country, optional: true
  belongs_to :province, optional: true
  belongs_to :city, optional: true

  geocoded_by :address
  after_validation :geocode

end
