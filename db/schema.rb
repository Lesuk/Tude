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

ActiveRecord::Schema.define(version: 20150604134650) do

  create_table "activities", force: :cascade do |t|
    t.integer  "trackable_id",   limit: 4
    t.string   "trackable_type", limit: 255
    t.integer  "owner_id",       limit: 4,   null: false
    t.integer  "recipient_id",   limit: 4
    t.integer  "category_id",    limit: 4
    t.string   "key",            limit: 255
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "parent_type",    limit: 255
    t.integer  "parent_id",      limit: 4
  end

  add_index "activities", ["category_id"], name: "index_activities_on_category_id", using: :btree
  add_index "activities", ["owner_id"], name: "index_activities_on_owner_id", using: :btree
  add_index "activities", ["parent_id", "parent_type"], name: "index_activities_on_parent_id_and_parent_type", using: :btree
  add_index "activities", ["recipient_id"], name: "index_activities_on_recipient_id", using: :btree
  add_index "activities", ["trackable_type", "trackable_id"], name: "index_activities_on_trackable_type_and_trackable_id", using: :btree

  create_table "article_progresses", force: :cascade do |t|
    t.integer  "student_id", limit: 4, null: false
    t.integer  "article_id", limit: 4, null: false
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "article_progresses", ["article_id"], name: "index_article_progresses_on_article_id", using: :btree
  add_index "article_progresses", ["student_id", "article_id"], name: "index_article_progresses_on_student_id_and_article_id", unique: true, using: :btree
  add_index "article_progresses", ["student_id"], name: "index_article_progresses_on_student_id", using: :btree

  create_table "articles", force: :cascade do |t|
    t.string   "title",             limit: 255
    t.string   "description",       limit: 255
    t.text     "body",              limit: 65535
    t.integer  "course_id",         limit: 4
    t.integer  "category_id",       limit: 4
    t.integer  "user_id",           limit: 4
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.integer  "section_id",        limit: 4
    t.string   "youtube_id",        limit: 255
    t.integer  "comments_count",    limit: 4,     default: 0,   null: false
    t.string   "status",            limit: 255,   default: "0", null: false
    t.integer  "video_duration",    limit: 4,     default: 0,   null: false
    t.string   "demo_link",         limit: 255
    t.string   "github_link",       limit: 255
    t.string   "slug",              limit: 255,                 null: false
    t.integer  "position",          limit: 4,                   null: false
    t.integer  "views_count",       limit: 4,     default: 0,   null: false
    t.integer  "subscribers_count", limit: 4,     default: 0,   null: false
  end

  add_index "articles", ["category_id"], name: "index_articles_on_category_id", using: :btree
  add_index "articles", ["course_id"], name: "index_articles_on_course_id", using: :btree
  add_index "articles", ["position"], name: "index_articles_on_position", using: :btree
  add_index "articles", ["section_id"], name: "index_articles_on_section_id", using: :btree
  add_index "articles", ["slug"], name: "index_articles_on_slug", unique: true, using: :btree
  add_index "articles", ["user_id"], name: "index_articles_on_user_id", using: :btree

  create_table "categories", force: :cascade do |t|
    t.string   "name",              limit: 255
    t.string   "description",       limit: 255
    t.integer  "parent_id",         limit: 4
    t.integer  "articles_count",    limit: 4,   default: 0, null: false
    t.integer  "courses_count",     limit: 4,   default: 0, null: false
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.string   "slug",              limit: 255,             null: false
    t.integer  "subscribers_count", limit: 4,   default: 0, null: false
  end

  add_index "categories", ["parent_id"], name: "index_categories_on_parent_id", using: :btree
  add_index "categories", ["slug"], name: "index_categories_on_slug", unique: true, using: :btree

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
    t.string   "title",             limit: 255
    t.string   "summary",           limit: 255
    t.text     "body",              limit: 65535
    t.text     "content",           limit: 65535
    t.string   "level",             limit: 255
    t.string   "youtube_id",        limit: 255
    t.integer  "category_id",       limit: 4
    t.integer  "users_count",       limit: 4,     default: 0,   null: false
    t.integer  "articles_count",    limit: 4,     default: 0,   null: false
    t.integer  "reviews_count",     limit: 4,     default: 0,   null: false
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.integer  "user_id",           limit: 4
    t.integer  "duration",          limit: 4,     default: 0,   null: false
    t.string   "slug",              limit: 255,                 null: false
    t.float    "rating",            limit: 24,    default: 0.0, null: false
    t.integer  "views_count",       limit: 4,     default: 0,   null: false
    t.integer  "subscribers_count", limit: 4,     default: 0,   null: false
  end

  add_index "courses", ["category_id"], name: "index_courses_on_category_id", using: :btree
  add_index "courses", ["slug"], name: "index_courses_on_slug", unique: true, using: :btree
  add_index "courses", ["user_id"], name: "index_courses_on_user_id", using: :btree

  create_table "enrollments", force: :cascade do |t|
    t.integer  "user_id",    limit: 4,             null: false
    t.integer  "course_id",  limit: 4,             null: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "status",     limit: 4, default: 0, null: false
  end

  add_index "enrollments", ["course_id", "user_id"], name: "index_enrollments_on_course_id_and_user_id", unique: true, using: :btree
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

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",           limit: 255, null: false
    t.integer  "sluggable_id",   limit: 4,   null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope",          limit: 255
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "mentions", force: :cascade do |t|
    t.integer  "mentionable_id",   limit: 4
    t.string   "mentionable_type", limit: 255
    t.integer  "user_id",          limit: 4
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "mentions", ["mentionable_type", "mentionable_id"], name: "index_mentions_on_mentionable_type_and_mentionable_id", using: :btree
  add_index "mentions", ["user_id"], name: "index_mentions_on_user_id", using: :btree

  create_table "reviews", force: :cascade do |t|
    t.integer  "course_id",  limit: 4,                 null: false
    t.integer  "user_id",    limit: 4,                 null: false
    t.text     "body",       limit: 65535,             null: false
    t.integer  "rating",     limit: 4,     default: 5, null: false
    t.integer  "progress",   limit: 4,     default: 0, null: false
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.integer  "status",     limit: 4,     default: 0, null: false
  end

  add_index "reviews", ["course_id", "user_id"], name: "index_reviews_on_course_id_and_user_id", unique: true, using: :btree
  add_index "reviews", ["course_id"], name: "index_reviews_on_course_id", using: :btree
  add_index "reviews", ["user_id"], name: "index_reviews_on_user_id", using: :btree

  create_table "sections", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "course_id",  limit: 4
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "duration",   limit: 4,   default: 0, null: false
    t.integer  "position",   limit: 4
  end

  add_index "sections", ["course_id"], name: "index_sections_on_course_id", using: :btree
  add_index "sections", ["position"], name: "index_sections_on_position", using: :btree

  create_table "subscriptions", force: :cascade do |t|
    t.integer  "subscriber_id",     limit: 4,   null: false
    t.integer  "subscribable_id",   limit: 4,   null: false
    t.string   "subscribable_type", limit: 255, null: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "subscriptions", ["subscribable_type", "subscribable_id"], name: "index_subscriptions_on_subscribable_type_and_subscribable_id", using: :btree
  add_index "subscriptions", ["subscriber_id"], name: "index_subscriptions_on_subscriber_id", using: :btree

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
    t.integer  "views_count",            limit: 4,     default: 0,  null: false
    t.integer  "courses_count",          limit: 4,     default: 0,  null: false
    t.integer  "articles_count",         limit: 4,     default: 0,  null: false
    t.integer  "comments_count",         limit: 4,     default: 0,  null: false
    t.integer  "questions_count",        limit: 4,     default: 0,  null: false
    t.integer  "answers_count",          limit: 4,     default: 0,  null: false
    t.integer  "subscribers_count",      limit: 4,     default: 0,  null: false
    t.integer  "reviews_count",          limit: 4,     default: 0,  null: false
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "views", force: :cascade do |t|
    t.integer  "viewable_id",   limit: 4
    t.string   "viewable_type", limit: 255
    t.string   "guest_ip",      limit: 255
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "views", ["viewable_type", "viewable_id"], name: "index_views_on_viewable_type_and_viewable_id", using: :btree

end
