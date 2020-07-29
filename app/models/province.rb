class Province < ApplicationRecord
  belongs_to :country
  has_many :cities
  has_many :billing_addresses

end
