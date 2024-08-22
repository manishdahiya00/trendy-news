class Order < ApplicationRecord
  belongs_to :product
  belongs_to :shopit_user
end
