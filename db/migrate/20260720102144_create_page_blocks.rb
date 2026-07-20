class CreatePageBlocks < ActiveRecord::Migration[8.1]
  def change
    create_table :page_blocks do |t|
      t.references :landing_page, null: false, foreign_key: true
      t.integer :position
      t.string :block_type
      t.json :content

      t.timestamps
    end
  end
end
