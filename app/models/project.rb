class Project < ApplicationRecord
  has_many_attached :images
  belongs_to :company
  def user
    self.company.user
  end
end
