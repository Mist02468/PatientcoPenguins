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

ActiveRecord::Schema.define(version: 20150810202307) do

  create_table "events", force: :cascade do |t|
    t.string   "topic"
    t.datetime "startTime"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "messages", force: :cascade do |t|
    t.string   "subject"
    t.text     "text"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "sender_id"
    t.integer  "recipient_id"
  end

  create_table "posts", force: :cascade do |t|
    t.integer  "type",               default: 0
    t.text     "text"
    t.integer  "voteCount",          default: 0
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "user_id"
    t.integer  "originatingPost_id"
  end

  add_index "posts", ["user_id"], name: "index_posts_on_user_id"

  create_table "tags", force: :cascade do |t|
    t.string "name"
  end

  create_table "tags_on_post", id: false, force: :cascade do |t|
    t.integer "post_id", null: false
    t.integer "tag_id",  null: false
  end

  create_table "user_tag_subscriptions", id: false, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "tag_id",  null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "firstName"
    t.string   "lastName"
    t.string   "location"
    t.integer  "industry"
    t.integer  "numConnections"
    t.string   "position"
    t.string   "company"
    t.integer  "reportedCount"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "subscribingUser_id"
  end

  create_table "users_attending_event", id: false, force: :cascade do |t|
    t.integer "event_id", null: false
    t.integer "user_id",  null: false
  end

end
