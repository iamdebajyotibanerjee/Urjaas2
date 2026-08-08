# app/models/blog_post.rb
class BlogPost < ApplicationRecord
  enum :status, { draft: 0, published: 1 }, default: :draft

  validates :title, presence: true
  validates :body, presence: true
end
