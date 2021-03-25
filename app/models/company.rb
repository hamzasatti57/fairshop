class Company < ApplicationRecord
  has_one_attached :image
  belongs_to :user
  has_many :projects, dependent: :destroy
  has_many :products, dependent: :destroy
end
