class User < ApplicationRecord
  has_one_attached :resume
  has_one :profile, dependent: :destroy
  has_many :companies, dependent: :destroy
  has_many :user_cart_products
  has_many :products, through: :user_cart_products
  has_many :projects, through: :companies
  has_many :products, through: :companies
  has_many :jobs, dependent: :destroy
  has_many :advertisements, dependent: :destroy
  has_many :comments, class_name: "Comment", foreign_key: "parent_id"
  has_many :ratings, class_name: "Rating", foreign_key: "parent_id"
  has_many :likes, class_name: "Like", foreign_key: "parent_id"
  has_many :customer_comments, class_name: "Comment", foreign_key: "user_id"
  has_many :customer_ratings, class_name: "Rating", foreign_key: "user_id"
  has_many :customer_likes, class_name: "Like", foreign_key: "user_id"
  validates :username,
            uniqueness:{allow_nil: true, case_sensitive: false}
  VALID_EMAIL_REGEX = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence: true,
            uniqueness: {case_sensitive: false},
            length: {maximum: 105},
            format: {with: VALID_EMAIL_REGEX}
  enum role: {admin: 0, vendor: 1, customer: 2}
  acts_as_punchable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :category, optional: true
  belongs_to :city, optional: true



  after_create :create_profile
  after_create :create_company

  scope :vendors, -> { where(role: 1) }
  delegate :title, to: :category, prefix: :category, allow_nil: true
  delegate :title, to: :city, prefix: :city, allow_nil: true
  scope :product_vendors, -> {
    category_ids = Category.where(title: Category.product_categories).pluck(:id)
    vendors.where(category_id: category_ids)
  }
  def is_admin?
    self.role == 'admin'
  end
  def is_vendor?
    self.role == 'vendor'
  end
  def is_customer?
    self.role == 'customer'
  end
  def full_name
    [first_name, last_name].join(" ")
  end

  def display_products?
    Category.product_categories.include? self.category_title
  end

  def display_projects?
    Category.project_categories.include? self.category_title
  end

  private

  def create_profile
    if self.is_vendor?
      self.create_profile!
    end
  end
  def create_company
    if self.is_vendor?
      self.companies.create(title: self.full_name)
    end
  end

end
