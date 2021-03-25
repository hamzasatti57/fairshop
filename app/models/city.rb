class City < ApplicationRecord
  has_one_attached :image
  validates :title, uniqueness: true
  # has_one :user, dependent: :destroy
  belongs_to :country, optional: true
  belongs_to :province
  has_many :jobs
  has_many :billing_addresses
end
