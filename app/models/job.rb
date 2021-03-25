class Job < ApplicationRecord
  has_one_attached :image
  belongs_to :user
  belongs_to :city
  def next
    Job.where("id > ?", id).first
  end

  def prev
    Job.where("id < ?", id).last
  end
end
