class ShopitUser < ApplicationRecord
  has_many :shopit_app_opens, dependent: :destroy
  has_many :carts, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :checkouts, dependent: :destroy
end
