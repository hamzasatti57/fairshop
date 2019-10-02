class Profile < ApplicationRecord
  has_one_attached :image
  belongs_to :user
  enum gender: {male: 0, female: 1}
  delegate :first_name, :last_name, :category_title, :full_name, to: :user, prefix: :user, allow_nil: true
end
