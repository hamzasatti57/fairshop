class Country < ApplicationRecord
  has_many :users
  has_many :jobs
end
