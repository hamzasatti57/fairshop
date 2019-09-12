class Store < ApplicationRecord
  belongs_to :vender
  has_many :pictures, as: :imageable
  mount_uploader :picture_name, PictureUploader
end
