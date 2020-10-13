class ProductCategory < ApplicationRecord
  # acts_as_punchable
  has_many :products, dependent: :destroy
  belongs_to :category
  belongs_to :super_category, optional: true
  has_one_attached :image
end
