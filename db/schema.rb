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

ActiveRecord::Schema[7.0].define(version: 2022_11_21_200701) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "project_management_assignees", force: :cascade do |t|
    t.string "user_identifier"
    t.string "email"
    t.bigint "task_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_project_management_assignees_on_email"
    t.index ["task_id"], name: "index_project_management_assignees_on_task_id"
    t.index ["user_identifier", "task_id"], name: "index_assignees_on_uid_and_task"
  end

  create_table "project_management_projects", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.string "identifier", null: false
    t.string "user_identifier"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identifier"], name: "index_project_management_projects_on_identifier", unique: true
    t.index ["user_identifier"], name: "index_project_management_projects_on_user_identifier"
  end

  create_table "project_management_tasks", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "identifier"
    t.bigint "project_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identifier"], name: "index_project_management_tasks_on_identifier", unique: true
    t.index ["project_id"], name: "index_project_management_tasks_on_project_id"
  end

  create_table "user_access_users", force: :cascade do |t|
    t.string "identifier", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "first_name"
    t.string "last_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_user_access_users_on_email", unique: true
    t.index ["identifier"], name: "index_user_access_users_on_identifier", unique: true
  end

  add_foreign_key "project_management_assignees", "project_management_tasks", column: "task_id", on_delete: :cascade
  add_foreign_key "project_management_tasks", "project_management_projects", column: "project_id", on_delete: :cascade
end
