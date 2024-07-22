class User < ApplicationRecord
  has_many :app_opens, dependent: :destroy
  has_many :saved, dependent: :destroy
end
