class UserCart < ApplicationRecord
  belongs_to :user
  has_one :checkout
end
