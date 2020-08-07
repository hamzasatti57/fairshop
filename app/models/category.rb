class Category < ApplicationRecord
  has_many :users
  has_many :sub_categories, class_name: "Category",
           foreign_key: "parent_id"

  has_many :product_categories
  belongs_to :parent, class_name: "Category", optional: true
  has_one_attached :image

  enum category_type: {
    "General" => 1,
    "Feature" => 2
  }  

  def self.product_categories
    ["Furniture", "Kitchens", "Paints", "Tiles", "Sanitary", "Doors & Wardrobes" ]
  end

  def self.project_categories
    ["Interior Designer", "Architects", "Product Designer"]
  end
end
