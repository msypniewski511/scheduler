class Tag < ApplicationRecord
  has_many :taggings
  has_many :events, through: :taggings
end
