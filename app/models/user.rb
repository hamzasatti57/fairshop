class User < ApplicationRecord
  has_one :profile, dependent: :destroy
  has_many :companies, dependent: :destroy
  has_many :projects, through: :companies
  has_many :products, through: :companies
  has_many :jobs, dependent: :destroy
  validates :username, presence: true,
            uniqueness:{case_sensitive: false},
            length:{minimum: 3, maximum: 25}
  VALID_EMAIL_REGEX = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence: true,
            uniqueness: {case_sensitive: false},
            length: {maximum: 105},
            format: {with: VALID_EMAIL_REGEX}
  enum role: {admin: 0, vendor: 1, buyer: 2}
  acts_as_punchable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :category
  belongs_to :city



  after_create :create_profile
  after_create :create_company

  scope :vendors, -> { where(role: 1) }
  delegate :title, to: :category, prefix: :category, allow_nil: true
  delegate :title, to: :city, prefix: :city, allow_nil: true

  def is_admin?
    self.role == 'admin'
  end
  def is_vendor?
    self.role == 'vendor'
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
