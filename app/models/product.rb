class Product < ApplicationRecord

  # has_many :punches, as: :punchable, dependent: :destroy
  has_many_attached :images
  belongs_to :product_category
  belongs_to :product_type, optional: true
  belongs_to :company
  # belongs_to :user, through: :company
  # has_many :user, through: :company
  has_and_belongs_to_many :colors
  has_many :comments, class_name: "Comment", foreign_key: "parent_id"
  has_many :ratings, class_name: "Rating", foreign_key: "parent_id"
  has_many :likes, class_name: "Like", foreign_key: "parent_id"
  acts_as_punchable
  scope :search_filter, -> (product_category_id) {
    filters = {}
    # price_range = price_range.split(',').map{ |s| s.to_f }
    filters[:product_category_id] = product_category_id if product_category_id != ""
    # filters[:product_type_id] = product_type_id if product_type_id != ""
    # filters[:price] = price_range.first..price_range.last
    where(filters)
  }

  def add_colors color_ids
    if color_ids.present?
      colors = Color.where(id: color_ids)
      self.colors << colors
    end
  end

  def update_colors color_ids
    self.colors.destroy_all
    if color_ids.present?
      colors = Color.where(id: color_ids)
      self.colors << colors
    end
  end

  def user
    self.company.user
  end
  scope :search, -> (q, location) {
    if q && location
      profiles = Profile.where('lower(address) LIKE ?', "%#{location.downcase}%")
      if profiles.any?
        users = User.where(id: profiles.pluck(:user_id))
        companies = Company.where(user_id: users.ids)
        where("company_id IN (?) AND lower(title) LIKE ?", companies.ids, "%#{q.downcase}%")
      else
        where('lower(title) LIKE ?', "%#{q.downcase}%")
      end
    else
      []
    end
  }


end
