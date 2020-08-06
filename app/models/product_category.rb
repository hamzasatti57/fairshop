class ProductCategory < ApplicationRecord
  # acts_as_punchable
  has_many :products, dependent: :destroy
  belongs_to :category
  belongs_to :super_category, optional: true
  has_many_attached :images
end
