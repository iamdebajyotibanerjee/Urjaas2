class LandingPage < ApplicationRecord
  has_many :page_blocks, dependent: :destroy
end
