class ShopitCategory < ApplicationRecord
  has_many :products, dependent: :destroy
end
