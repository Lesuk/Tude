# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150419153304) do

  create_table "article_views", force: :cascade do |t|
    t.string   "guest_ip",   limit: 255
    t.integer  "article_id", limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "article_views", ["article_id"], name: "index_article_views_on_article_id", using: :btree

  create_table "articles", force: :cascade do |t|
    t.string   "title",               limit: 255
    t.string   "description",         limit: 255
    t.text     "body",                limit: 65535
    t.integer  "course_id",           limit: 4
    t.integer  "category_id",         limit: 4
    t.integer  "user_id",             limit: 4
    t.string   "slug",                limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.integer  "article_views_count", limit: 4,     default: 0,   null: false
    t.integer  "section_id",          limit: 4
    t.string   "youtube_id",          limit: 255
    t.integer  "comments_count",      limit: 4,     default: 0,   null: false
    t.string   "status",              limit: 255,   default: "0", null: false
    t.integer  "video_duration",      limit: 4,     default: 0,   null: false
    t.string   "demo_link",           limit: 255
    t.string   "github_link",         limit: 255
  end

  add_index "articles", ["category_id"], name: "index_articles_on_category_id", using: :btree
  add_index "articles", ["course_id"], name: "index_articles_on_course_id", using: :btree
  add_index "articles", ["section_id"], name: "index_articles_on_section_id", using: :btree
  add_index "articles", ["slug"], name: "index_articles_on_slug", using: :btree
  add_index "articles", ["user_id"], name: "index_articles_on_user_id", using: :btree

  create_table "categories", force: :cascade do |t|
    t.string   "name",           limit: 255
    t.string   "description",    limit: 255
    t.string   "slug",           limit: 255
    t.integer  "parent_id",      limit: 4
    t.integer  "articles_count", limit: 4,   default: 0, null: false
    t.integer  "courses_count",  limit: 4,   default: 0, null: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  add_index "categories", ["parent_id"], name: "index_categories_on_parent_id", using: :btree
  add_index "categories", ["slug"], name: "index_categories_on_slug", using: :btree

  create_table "comments", force: :cascade do |t|
    t.integer  "commentable_id",   limit: 4
    t.string   "commentable_type", limit: 255
    t.integer  "user_id",          limit: 4
    t.integer  "parent_id",        limit: 4
    t.text     "body",             limit: 65535
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "subparent_id",     limit: 4
  end

  add_index "comments", ["commentable_type", "commentable_id"], name: "index_comments_on_commentable_type_and_commentable_id", using: :btree
  add_index "comments", ["parent_id"], name: "index_comments_on_parent_id", using: :btree
  add_index "comments", ["subparent_id"], name: "index_comments_on_subparent_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "courses", force: :cascade do |t|
    t.string   "title",          limit: 255
    t.string   "summary",        limit: 255
    t.text     "description",    limit: 65535
    t.string   "slug",           limit: 255
    t.text     "content",        limit: 65535
    t.string   "level",          limit: 255
    t.string   "youtube_id",     limit: 255
    t.integer  "category_id",    limit: 4
    t.integer  "users_count",    limit: 4,     default: 0, null: false
    t.integer  "articles_count", limit: 4,     default: 0, null: false
    t.integer  "reviews_count",  limit: 4,     default: 0, null: false
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.integer  "user_id",        limit: 4
    t.integer  "duration",       limit: 4,     default: 0, null: false
  end

  add_index "courses", ["category_id"], name: "index_courses_on_category_id", using: :btree
  add_index "courses", ["slug"], name: "index_courses_on_slug", unique: true, using: :btree
  add_index "courses", ["user_id"], name: "index_courses_on_user_id", using: :btree

  create_table "enrollments", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.integer  "course_id",  limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "enrollments", ["course_id"], name: "index_enrollments_on_course_id", using: :btree
  add_index "enrollments", ["user_id"], name: "index_enrollments_on_user_id", using: :btree

  create_table "favorites", force: :cascade do |t|
    t.integer  "user_id",        limit: 4
    t.integer  "favorable_id",   limit: 4
    t.string   "favorable_type", limit: 255
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "favorites", ["favorable_type", "favorable_id"], name: "index_favorites_on_favorable_type_and_favorable_id", using: :btree
  add_index "favorites", ["user_id", "favorable_id", "favorable_type"], name: "index_favorites_on_user_id_and_favorable_id_and_favorable_type", unique: true, using: :btree
  add_index "favorites", ["user_id"], name: "index_favorites_on_user_id", using: :btree

  create_table "mentions", force: :cascade do |t|
    t.integer  "mentionable_id",   limit: 4
    t.string   "mentionable_type", limit: 255
    t.integer  "user_id",          limit: 4
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "mentions", ["mentionable_type", "mentionable_id"], name: "index_mentions_on_mentionable_type_and_mentionable_id", using: :btree
  add_index "mentions", ["user_id"], name: "index_mentions_on_user_id", using: :btree

  create_table "sections", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "course_id",  limit: 4
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "duration",   limit: 4,   default: 0, null: false
  end

  add_index "sections", ["course_id"], name: "index_sections_on_course_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255,   default: "", null: false
    t.string   "encrypted_password",     limit: 255,   default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,     default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username",               limit: 255
    t.string   "fullname",               limit: 255
    t.text     "bio",                    limit: 65535
    t.string   "whois",                  limit: 255
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
