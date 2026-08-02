# app/models/landing_page.rb
class LandingPage < ApplicationRecord
  has_many :page_blocks, -> { order(position: :asc) }, dependent: :destroy

  enum :status, { draft: 0, published: 1 }, default: :draft

  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true

  # Automatically format slug on save
  before_validation :generate_slug, if: -> { slug.blank? && title.present? }

  private

  def generate_slug
    self.slug = title.parameterize
  end
end
