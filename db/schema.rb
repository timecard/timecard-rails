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

ActiveRecord::Schema.define(version: 20131027003223) do

  create_table "authentications", force: true do |t|
    t.integer  "user_id",     default: 0,  null: false
    t.string   "provider",    default: "", null: false
    t.integer  "uid",         default: 0,  null: false
    t.string   "username",    default: "", null: false
    t.string   "oauth_token", default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", force: true do |t|
    t.text     "body"
    t.integer  "issue_id",   null: false
    t.integer  "user_id",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "issues", force: true do |t|
    t.string   "subject",                        default: "", null: false
    t.text     "description"
    t.datetime "will_start_at"
    t.integer  "status",                         default: 1,  null: false
    t.datetime "closed_on"
    t.integer  "project_id",                                  null: false
    t.integer  "author_id",                                   null: false
    t.integer  "assignee_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "info",          limit: 16777215
  end

  create_table "members", force: true do |t|
    t.integer  "user_id",    default: 0,     null: false
    t.integer  "project_id", default: 0,     null: false
    t.boolean  "is_admin",   default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", force: true do |t|
    t.string   "name",        default: "",   null: false
    t.text     "description"
    t.boolean  "is_public",   default: true, null: false
    t.integer  "parent_id"
    t.integer  "status",      default: 1,    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "providers", force: true do |t|
    t.string  "name"
    t.integer "provided_id"
    t.string  "provided_type"
    t.text    "info",          limit: 16777215
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",                   default: "", null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "work_logs", force: true do |t|
    t.datetime "start_at"
    t.datetime "end_at"
    t.integer  "issue_id",   null: false
    t.integer  "user_id",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
