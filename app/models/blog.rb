class Blog < ApplicationRecord
  # acts_as_punchable
  has_one_attached :image
  scope :search, -> (q) {
    if q
      @blogs = Blog.where('lower(title) LIKE ?', "%#{q.downcase}%")
    else
      []
    end
  }
  def next
    Blog.where("id > ?", id).first
  end

  def prev
    Blog.where("id < ?", id).last
  end
end
