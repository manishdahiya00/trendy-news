class AstrologyAppBanner < ApplicationRecord
	scope :active, -> { where( status: true ) }
end
