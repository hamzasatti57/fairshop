class Advertisement < ApplicationRecord
  acts_as_punchable
  has_one_attached :image
  belongs_to :user
  def next
    Advertisement.where("id > ?", id).first
  end

  def prev
    Advertisement.where("id < ?", id).last
  end

end
