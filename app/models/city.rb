class City < ApplicationRecord
  has_one_attached :image
  validates :title, uniqueness: true
  has_one :user, dependent: :destroy
  belongs_to :country
end
