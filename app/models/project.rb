class Project < ApplicationRecord
  has_many_attached :images
  belongs_to :company
  has_many :comments, class_name: "Comment", foreign_key: "parent_id"
  has_many :ratings, class_name: "Rating", foreign_key: "parent_id"
  def user
    self.company.user
  end
end
