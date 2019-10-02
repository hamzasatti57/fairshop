class Category < ApplicationRecord
  has_many :users

  def self.product_categories
    ["Furniture", "Upholstery & Repair", "Paints", "Tiles", "Sanitary", "Appliances" ]
  end

  def self.project_categories
    ["Interior Designer", "Architects",]
  end
end
