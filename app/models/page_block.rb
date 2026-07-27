class PageBlock < ApplicationRecord
  belongs_to :landing_page
  validates :block_type, presence: true

  # Default templates dictionary
  TEMPLATES = {
    "hero" => {
      name: "Hero Section",
      description: "High-impact headline, subtitle, and primary call-to-action button.",
      icon: "bi-star", # or any icon class you use
      default_data: {
        "title" => "Build Something Great Today",
        "subtitle" => "Turn your ideas into high-converting landing pages in minutes.",
        "cta_text" => "Get Started Free",
        "cta_url" => "#"
      }
    },
    "features" => {
      name: "Features Grid",
      description: "3-column grid highlighting key product benefits or services.",
      icon: "bi-grid",
      default_data: {
        "heading" => "Why Choose Us",
        "subheading" => "Everything you need to scale your business.",
        "items" => [
          { "title" => "Lightning Fast", "description" => "Optimized for maximum conversion speed." },
          { "title" => "Easy Customization", "description" => "No coding knowledge required." },
          { "title" => "Analytics Ready", "description" => "Track your growth with built-in tools." }
        ]
      }
    },
    "cta" => {
      name: "Call To Action",
      description: "Focused closing section designed to drive conversions.",
      icon: "bi-mega-phone",
      default_data: {
        "headline" => "Ready to transform your workflow?",
        "button_text" => "Start Your Free Trial",
        "button_url" => "#"
      }
    },
    "faq" => {
      name: "FAQ Accordion",
      description: "Frequently asked questions to resolve buyer friction.",
      icon: "bi-question-circle",
      default_data: {
        "title" => "Frequently Asked Questions",
        "questions" => [
          { "q" => "How long does setup take?", "a" => "You can launch your first page in under 5 minutes." },
          { "q" => "Can I cancel anytime?", "a" => "Yes, there are no long-term contracts or hidden fees." }
        ]
      }
    }
  }.freeze

  before_validation :apply_template_defaults, on: :create

  private

  def apply_template_defaults
    return if data.present? || block_type.blank?

    template = TEMPLATES[block_type]
    self.data = template[:default_data] if template
  end
end
