class ProductCategory < ApplicationRecord
  # acts_as_punchable
  has_many :products
  belongs_to :category
  belongs_to :super_category, optional: true
end
