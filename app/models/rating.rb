class Rating < ApplicationRecord
  belongs_to :product, optional: true,    class_name: "Product", foreign_key: "parent_id"
  belongs_to :project, optional: true, class_name: "Project", foreign_key: "parent_id"
  belongs_to :user, optional: true,    class_name: "User", foreign_key: "parent_id"
  belongs_to :rater, class_name: 'User', foreign_key: 'user_id'
  belongs_to :user

  enum parent_type: {
      product: 0,
      project: 1,
      user: 2
  }

  def self.parent_type_product
    'product'
  end
  def self.parent_type_project
    'project'
  end

  def parent
    if parent_type == 'product'
      self.product
    elsif parent_type == 'project'
      self.project
    elsif parent_type == 'user'
      self.user
    end
  end
end
