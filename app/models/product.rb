class Product < ApplicationRecord
  has_many_attached :images
  belongs_to :user
  belongs_to :product_category
  belongs_to :product_type
  has_and_belongs_to_many :colors

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

end
