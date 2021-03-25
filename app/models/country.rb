class Country < ApplicationRecord
  has_many :users
  has_many :billing_addresses
end
