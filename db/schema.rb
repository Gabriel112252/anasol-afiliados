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

ActiveRecord::Schema[7.2].define(version: 2026_06_22_000003) do
  create_table "admins", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
  end

  create_table "affiliates", force: :cascade do |t|
    t.string "full_name", null: false
    t.string "cpf", null: false
    t.string "email", null: false
    t.string "whatsapp", null: false
    t.string "tiktok", null: false
    t.string "zip_code", null: false
    t.string "street", null: false
    t.string "number", null: false
    t.string "complement"
    t.string "neighborhood", null: false
    t.string "city", null: false
    t.string "state", null: false
    t.boolean "terms_accepted", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cpf"], name: "index_affiliates_on_cpf", unique: true
    t.index ["email"], name: "index_affiliates_on_email", unique: true
  end
end
