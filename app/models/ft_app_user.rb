class FtAppUser < ApplicationRecord
  has_many :ft_app_opens, dependent: :destroy
end
