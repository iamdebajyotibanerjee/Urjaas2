require "test_helper"

class PageBlockTest < ActiveSupport::TestCase
  self.fixture_table_names = []

  test "image_blob_for returns only images attached to this block" do
    landing_page = LandingPage.create!(title: "Image Test #{SecureRandom.hex(4)}")
    block = landing_page.page_blocks.create!(block_type: "hero")
    other_block = landing_page.page_blocks.create!(block_type: "hero")
    blob = ActiveStorage::Blob.create_and_upload!(
      io: StringIO.new("test image data"),
      filename: "feature.png",
      content_type: "image/png",
      identify: false
    )

    block.images.attach(blob)

    assert_equal blob, block.image_blob_for(blob.signed_id)
    assert_nil other_block.image_blob_for(blob.signed_id)
    assert_nil block.image_blob_for("not-a-valid-signed-id")
  ensure
    blob&.purge
  end
end
