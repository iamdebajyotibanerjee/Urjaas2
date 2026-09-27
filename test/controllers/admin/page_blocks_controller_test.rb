require "test_helper"
require "base64"
require "tempfile"

module Admin
  class PageBlocksControllerTest < ActionDispatch::IntegrationTest
    self.fixture_table_names = []
    include Devise::Test::IntegrationHelpers

    test "requires authentication for admin pages and block actions" do
      landing_page = LandingPage.create!(title: "Auth Test #{SecureRandom.hex(4)}")
      block = landing_page.page_blocks.create!(block_type: "hero")

      get admin_landing_pages_path
      assert_redirected_to new_user_session_path

      get admin_blog_posts_path
      assert_redirected_to new_user_session_path

      delete admin_landing_page_page_block_path(landing_page, block)
      assert_redirected_to new_user_session_path
      assert PageBlock.exists?(block.id)
    end

    test "does not allow non-admin accounts to access admin pages" do
      user = User.create!(email: "editor@example.test", password: "secure-password-123")
      sign_in user

      get admin_landing_pages_path

      assert_redirected_to new_user_session_path
    end

    test "uploads hero and item images to their page block" do
      landing_page = LandingPage.create!(title: "Upload Test #{SecureRandom.hex(4)}")
      block = landing_page.page_blocks.create!(block_type: "hero", content: { "items" => [ { "title" => "Feature" } ] })
      sign_in User.create!(email: User::ADMIN_EMAIL, password: "secure-password-123")
      hero_file = uploaded_png("hero.png")
      feature_file = uploaded_png("feature.png")

      patch admin_landing_page_page_block_path(landing_page, block), params: {
        page_block: {
          content_data: { items: { "0" => { title: "Feature" } } },
          images: { hero: hero_file, "0" => feature_file }
        }
      }

      assert_response :redirect
      block.reload
      assert_equal 2, block.images.count
      assert block.image_blob_for(block.content["image_signed_id"])
      assert block.image_blob_for(block.content["items"][0]["image_signed_id"])

      patch admin_landing_page_page_block_path(landing_page, block), params: {
        page_block: { content_data: { title: "Updated hero", image_signed_id: block.content["image_signed_id"], items: { "0" => block.content["items"][0] } } }
      }

      assert_response :redirect
      block.reload
      assert block.image_blob_for(block.content["image_signed_id"])
      assert block.image_blob_for(block.content["items"][0]["image_signed_id"])

      landing_page.update!(status: :published)
      get public_landing_page_path(slug: landing_page.slug)

      assert_response :success
      assert_select "img[src*='/rails/active_storage/blobs/redirect']"
    ensure
      block&.images&.purge
      hero_file&.close!
      feature_file&.close!
    end

    private

    def uploaded_png(filename)
      tempfile = Tempfile.new([ "page-block-image", ".png" ])
      tempfile.binmode
      tempfile.write(Base64.decode64("iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+/lS8AAAAASUVORK5CYII="))
      tempfile.rewind
      Rack::Test::UploadedFile.new(tempfile.path, "image/png", true, original_filename: filename)
    end
  end
end
