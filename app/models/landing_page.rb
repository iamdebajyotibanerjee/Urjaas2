# app/models/landing_page.rb
class LandingPage < ApplicationRecord
  has_many :page_blocks, -> { order(:position) }, dependent: :destroy

  before_validation :generate_slug, on: :create

  private

  def generate_slug
    return if slug.present?

    # Generates a slug from title, or falls back to a random token
    self.slug = title.present? ? title.parameterize : SecureRandom.hex(4)
  end
end
