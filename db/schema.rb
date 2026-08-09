# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_08_09_115818) do
  create_table "blog_posts", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", null: false
    t.integer "status", default: 0, null: false
    t.string "title"
    t.datetime "updated_at", null: false
  end

  create_table "landing_pages", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "published_at"
    t.string "slug"
    t.integer "status", default: 0, null: false
    t.text "title"
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_landing_pages_on_slug", unique: true
    t.index ["status"], name: "index_landing_pages_on_status"
  end

  create_table "page_blocks", force: :cascade do |t|
    t.string "block_type"
    t.json "content"
    t.datetime "created_at", null: false
    t.integer "landing_page_id", null: false
    t.integer "position"
    t.datetime "updated_at", null: false
    t.index ["landing_page_id"], name: "index_page_blocks_on_landing_page_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "page_blocks", "landing_pages"
end
