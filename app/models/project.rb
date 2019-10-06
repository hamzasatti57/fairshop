class Project < ApplicationRecord
  has_many_attached :images
  belongs_to :company
end
