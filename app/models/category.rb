class Category < ApplicationRecord
  has_many :users
  has_many :sub_categories, class_name: "Category",
           foreign_key: "parent_id"

  belongs_to :parent, class_name: "Category", optional: true



  def self.product_categories
    ["Furniture", "Kitchens", "Paints", "Tiles", "Sanitary", "Doors & Wardrobes" ]
  end

  def self.project_categories
    ["Interior Designer", "Architects", "Product Designer"]
  end
end
