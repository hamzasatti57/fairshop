class Project < ApplicationRecord
  has_many_attached :images
  belongs_to :company
  has_many :comments, class_name: "Comment", foreign_key: "parent_id"
  has_many :ratings, class_name: "Rating", foreign_key: "parent_id"
  has_many :likes, class_name: "Like", foreign_key: "parent_id"
  acts_as_punchable

  def user
    self.company.user
  end
end
