class Product < ApplicationRecord
  belongs_to :store
  has_many :pictures, as: :imageable
  mount_uploader :picture_name, PictureUploader
end
