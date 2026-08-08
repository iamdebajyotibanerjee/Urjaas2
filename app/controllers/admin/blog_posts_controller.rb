# app/controllers/admin/blog_posts_controller.rb
module Admin
  class BlogPostsController < ApplicationController
    before_action :set_blog_post, only: [ :show, :edit, :update, :destroy, :toggle_publish ]

    def index
      @blog_posts = BlogPost.order(created_at: :desc)
    end

    def show
    end

    def new
      @blog_post = BlogPost.new
    end

    def edit
    end

    def create
      @blog_post = BlogPost.new(blog_post_params)

      if @blog_post.save
        redirect_to admin_blog_posts_path, notice: "Blog post created successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @blog_post.update(blog_post_params)
        redirect_to admin_blog_posts_path, notice: "Blog post updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @blog_post.destroy
      redirect_to admin_blog_posts_path, notice: "Blog post deleted successfully."
    end

    def toggle_publish
      if @blog_post.published?
        @blog_post.draft!
      else
        @blog_post.published!
      end

      redirect_back fallback_location: admin_blog_posts_path, notice: "Status updated to #{@blog_post.status.titleize}."
    end

    private

    def set_blog_post
      @blog_post = BlogPost.find(params[:id])
    end

    def blog_post_params
      params.require(:blog_post).permit(:title, :body, :status)
    end
  end
end
