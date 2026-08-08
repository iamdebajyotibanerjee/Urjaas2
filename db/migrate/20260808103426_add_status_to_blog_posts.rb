class AddStatusToBlogPosts < ActiveRecord::Migration[7.1]
  def change
    add_column :blog_posts, :status, :integer, default: 0, null: false
  end
end
