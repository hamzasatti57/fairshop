class Province < ApplicationRecord
  belongs_to :country, optional: true
  has_many :cities
  has_many :billing_addresses
  
  validates :title, uniqueness: true

end
