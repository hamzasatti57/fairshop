class Vender < ApplicationRecord
	has_many :pictures, as: :imageable
	mount_uploader :picture_name, PictureUploader
	validates :name, presence: true
end
