class Category < ApplicationRecord
  has_many :articles, dependent: :destroy
  scope :active, -> { where(status: true) }
end
