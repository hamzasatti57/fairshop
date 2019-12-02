class ProductCategory < ApplicationRecord
  acts_as_punchable
  has_many :products
end
