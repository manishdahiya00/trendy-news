class DeletedUser < ApplicationRecord
  validates :email, presence: true
  validates :from, presence: true
end
