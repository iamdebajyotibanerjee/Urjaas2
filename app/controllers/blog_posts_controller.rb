# app/controllers/blog_posts_controller.rb
class BlogPostsController < ApplicationController
  # GET /blog_posts
  def index
    @blog_posts = BlogPost.published.order(created_at: :desc)
  end

  # GET /blog_posts/1
  def show
    @blog_post = BlogPost.published.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to blog_posts_path, alert: "Blog post not found or unpublished."
  end
end
