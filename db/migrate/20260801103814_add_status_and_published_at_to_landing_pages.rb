# db/migrate/2026xxxxxx_add_status_and_published_at_to_landing_pages.rb
class AddStatusAndPublishedAtToLandingPages < ActiveRecord::Migration[7.1]
  def change
    add_column :landing_pages, :status, :integer, default: 0, null: false
    add_column :landing_pages, :published_at, :datetime

    add_index :landing_pages, :status
  end
end
