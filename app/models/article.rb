class Article < ApplicationRecord
  belongs_to :category
  has_many :saved, dependent: :destroy
  scope :active, -> { where(status: true).order(created_at: :desc) }
end
