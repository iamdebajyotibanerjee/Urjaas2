require "test_helper"

class BlogPostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @blog_post = blog_posts(:one)
  end

  test "should get index" do
    get blog_posts_url
    assert_response :success
    assert_select "a", text: @blog_post.title
  end

  test "does not list draft blog posts" do
    get blog_posts_url
    assert_response :success
    assert_select "a", text: blog_posts(:two).title, count: 0
  end

  test "should show blog_post" do
    get blog_post_url(@blog_post)
    assert_response :success
    assert_select "h1", text: @blog_post.title
  end

  test "redirects when requesting a draft blog post" do
    get blog_post_url(blog_posts(:two))
    assert_redirected_to blog_posts_url
  end
end
