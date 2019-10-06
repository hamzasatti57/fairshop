class Category < ApplicationRecord
  has_many :users
  has_many :sub_categories, class_name: "Category",
           foreign_key: "parent_id"

  belongs_to :parent, class_name: "Category", optional: true

  def self.product_categories
    ["Furniture", "Upholstery & Repair", "Paints", "Tiles", "Sanitary", "Appliances" ]
  end

  def self.project_categories
    ["Interior Designer", "Architects",]
  end
end
