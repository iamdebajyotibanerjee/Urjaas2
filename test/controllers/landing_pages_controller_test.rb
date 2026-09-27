require "test_helper"

class LandingPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    landing_page = landing_pages(:one)
    landing_page.published!

    get public_landing_page_url(slug: landing_page.slug)
    assert_response :success
  end
end
