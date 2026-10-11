require "test_helper"

class LandingPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    landing_page = landing_pages(:one)
    landing_page.published!

    get public_landing_page_url(slug: landing_page.slug)
    assert_response :success
  end

  test "text block heading and body can use different alignments" do
    landing_page = LandingPage.create!(title: "Alignment Test #{SecureRandom.hex(4)}", status: :published)
    block = landing_page.page_blocks.create!(
      block_type: "text",
      content: {
        "title" => "Centered heading",
        "title_alignment" => "text-center",
        "body_alignment" => "text-right"
      }
    )
    block.update!(rich_content: "<p>Right-aligned body</p>")

    get public_landing_page_url(slug: landing_page.slug)

    assert_response :success
    assert_select "h2.text-center", text: "Centered heading"
    assert_select "div.prose.text-right p", text: "Right-aligned body"
  end
end
