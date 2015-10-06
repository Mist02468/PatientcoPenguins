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

ActiveRecord::Schema.define(version: 20151006125230) do

  create_table "events", force: :cascade do |t|
    t.string   "topic"
    t.datetime "startTime"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "host_id"
  end

  add_index "events", ["host_id"], name: "index_events_on_host_id"

  create_table "events_users", id: false, force: :cascade do |t|
    t.integer "event_id", null: false
    t.integer "user_id",  null: false
  end

  create_table "posts", force: :cascade do |t|
    t.integer  "kind",               default: 0
    t.text     "text"
    t.integer  "voteCount",          default: 0
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "user_id"
    t.integer  "originatingPost_id"
  end

  add_index "posts", ["user_id"], name: "index_posts_on_user_id"

  create_table "posts_tags", id: false, force: :cascade do |t|
    t.integer "post_id", null: false
    t.integer "tag_id",  null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
  end

  create_table "tags_users", id: false, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "tag_id",  null: false
  end

  create_table "user_subscriptions", force: :cascade do |t|
    t.integer  "subscriber_id"
    t.integer  "subscribed_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "user_subscriptions", ["subscribed_id"], name: "index_user_subscriptions_on_subscribed_id"
  add_index "user_subscriptions", ["subscriber_id", "subscribed_id"], name: "index_user_subscriptions_on_subscriber_id_and_subscribed_id", unique: true
  add_index "user_subscriptions", ["subscriber_id"], name: "index_user_subscriptions_on_subscriber_id"

  create_table "users", force: :cascade do |t|
    t.string   "firstName"
    t.string   "lastName"
    t.string   "location"
    t.string   "industry"
    t.integer  "numConnections"
    t.string   "position"
    t.string   "company"
    t.integer  "reportedCount"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "linkedInId"
    t.string   "emailAddress"
  end

end
