class CreateLandingPages < ActiveRecord::Migration[8.1]
  def change
    create_table :landing_pages do |t|
      t.text :title
      t.string :slug

      t.timestamps
    end
    add_index :landing_pages, :slug, unique: true
  end
end
