class Product < ApplicationRecord
  belongs_to :shopit_category
  has_many :carts, dependent: :destroy
  has_many :orders, dependent: :destroy
end
