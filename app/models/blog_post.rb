# app/models/blog_post.rb
class BlogPost < ApplicationRecord
  has_rich_text :content
  enum :status, { draft: 0, published: 1 }, default: :draft

  validates :title, presence: true
  validates :content, presence: true
end
