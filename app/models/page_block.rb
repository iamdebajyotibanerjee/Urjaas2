# app/models/page_block.rb
class PageBlock < ApplicationRecord
  belongs_to :landing_page

  validates :block_type, presence: true

  TEMPLATES = {
    "hero" => {
      name: "Hero Section",
      description: "High-impact headline, subtitle, and primary call-to-action button.",
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
    "products" => {
      name: "Products & Pricing Showcase",
      description: "2 or 3 column product cards with feature lists and pricing.",
      default_data: {
        "heading" => "Simple, Transparent Pricing",
        "subheading" => "Choose the plan or product that best fits your needs.",
        "columns" => 3, # Can be set to 2 or 3
        "items" => [
          {
            "name" => "Starter Pack",
            "price" => "$29",
            "period" => "/mo",
            "description" => "Perfect for solo creators and small projects.",
            "badge" => "",
            "featured" => false,
            "button_text" => "Get Started",
            "button_url" => "#",
            "features" => [ "Up to 3 Landing Pages", "Basic Analytics", "Community Support" ]
          },
          {
            "name" => "Pro Edition",
            "price" => "$79",
            "period" => "/mo",
            "description" => "For growing businesses needing higher scale.",
            "badge" => "Most Popular",
            "featured" => true,
            "button_text" => "Start Free Trial",
            "button_url" => "#",
            "features" => [ "Unlimited Landing Pages", "Custom Domain Support", "Advanced Analytics", "Priority Support" ]
          },
          {
            "name" => "Enterprise",
            "price" => "$199",
            "period" => "/mo",
            "description" => "Custom infrastructure and dedicated service.",
            "badge" => "",
            "featured" => false,
            "button_text" => "Contact Sales",
            "button_url" => "#",
            "features" => [ "Dedicated Account Manager", "SLA Guarantees", "Custom API Integrations" ]
          }
        ]
      }
    },
    "testimonials" => {
      name: "Testimonials Block",
      description: "Customer reviews with star ratings and author avatars.",
      default_data: {
        "heading" => "Loved by Creators & Builders",
        "subheading" => "See how our users are launching faster than ever.",
        "items" => [
          {
            "quote" => "Urjaas transformed how fast we launch new campaigns. We went from days of development to under 15 minutes!",
            "author" => "Alex Rivera",
            "role" => "Product Lead at Acme Corp",
            "avatar_url" => "https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=200",
            "rating" => 5
          },
          {
            "quote" => "The modular block approach gives us complete design freedom while keeping our code base super clean.",
            "author" => "Sarah Chen",
            "role" => "Growth Marketer",
            "avatar_url" => "https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&q=80&w=200",
            "rating" => 5
          }
        ]
      }
    },
    "social_gallery" => {
      name: "Social Media Wall",
      description: "A gallery of tweets, comments, and community feedback.",
      default_data: {
        "heading" => "What People Are Saying",
        "subheading" => "Real feedback collected across social channels.",
        "items" => [
          {
            "name" => "David K.",
            "handle" => "@tech_david",
            "platform" => "Twitter",
            "comment" => "Just launched our landing page in under 10 minutes using modular blocks. Mind blown! 🚀",
            "avatar_url" => "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&q=80&w=200",
            "date" => "2h ago"
          },
          {
            "name" => "Sarah M.",
            "handle" => "@sarah_growth",
            "platform" => "LinkedIn",
            "comment" => "Our team's conversion rate jumped 35% after redesigning with this layout engine. Highly recommended!",
            "avatar_url" => "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?auto=format&fit=crop&q=80&w=200",
            "date" => "1d ago"
          },
          {
            "name" => "Tom Wright",
            "handle" => "@dev_tom",
            "platform" => "Twitter",
            "comment" => "The Rails 8 + Tailwind setup here is so slick. Pure developer productivity gold.",
            "avatar_url" => "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&q=80&w=200",
            "date" => "3d ago"
          }
        ]
      }
    },
    "cta" => {
      name: "Call To Action",
      description: "Focused closing section designed to drive conversions.",
      default_data: {
        "headline" => "Ready to transform your workflow?",
        "button_text" => "Start Your Free Trial",
        "button_url" => "#"
      }
    },
    "faq" => {
      name: "FAQ Accordion",
      description: "Frequently asked questions to resolve buyer friction.",
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
    return if content.present? || block_type.blank?

    template = TEMPLATES[block_type]
    self.content = template[:default_data] if template
  end
end
