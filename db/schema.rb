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

ActiveRecord::Schema.define(version: 2018_08_27_093047) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "assignments", force: :cascade do |t|
    t.integer "user_id"
    t.string "assignable_type"
    t.integer "assignable_id"
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assignable_type", "assignable_id"], name: "index_assignments_on_assignable_type_and_assignable_id"
  end

  create_table "challenge_criteria", force: :cascade do |t|
    t.integer "challenge_id"
    t.integer "criterion_id"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "challenge_judgements", force: :cascade do |t|
    t.integer "challenge_criterion_id"
    t.integer "score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "challenge_scorecard_id"
  end

  create_table "challenge_scorecards", force: :cascade do |t|
    t.integer "entry_id"
    t.integer "assignment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "challenges", force: :cascade do |t|
    t.integer "region_id"
    t.integer "competition_id"
    t.string "name"
    t.text "short_desc"
    t.text "long_desc"
    t.text "eligibility"
    t.string "video_url"
    t.string "data_set_url"
    t.boolean "approved", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "checkpoints", force: :cascade do |t|
    t.integer "competition_id"
    t.datetime "end_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "max_regional_challenges"
    t.integer "max_national_challenges"
    t.string "name"
  end

  create_table "competitions", force: :cascade do |t|
    t.integer "year"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "start_time"
    t.datetime "end_time"
  end

  create_table "criteria", force: :cascade do |t|
    t.integer "competition_id"
    t.text "description"
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
  end

  create_table "data_sets", force: :cascade do |t|
    t.integer "region_id"
    t.integer "competition_id"
    t.string "name"
    t.string "url"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "entries", force: :cascade do |t|
    t.integer "team_id"
    t.integer "challenge_id"
    t.integer "checkpoint_id"
    t.text "justification"
    t.boolean "eligible"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "event_partnerships", force: :cascade do |t|
    t.integer "event_id"
    t.integer "sponsor_id"
    t.boolean "approved", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "events", force: :cascade do |t|
    t.integer "region_id"
    t.integer "competition_id"
    t.string "name"
    t.string "registration_type"
    t.integer "capacity"
    t.string "email"
    t.string "twitter"
    t.text "address"
    t.text "accessibility"
    t.text "youth_support"
    t.text "parking"
    t.text "public_transport"
    t.text "operation_hours"
    t.text "catering"
    t.string "video_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.boolean "approval"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "place_id"
    t.string "identifier"
    t.string "event_type"
    t.text "description"
    t.index ["identifier"], name: "index_events_on_identifier"
  end

  create_table "favourites", force: :cascade do |t|
    t.integer "assignment_id"
    t.integer "team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "peoples_judgements", force: :cascade do |t|
    t.integer "criterion_id"
    t.integer "score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "peoples_scorecard_id"
  end

  create_table "peoples_scorecards", force: :cascade do |t|
    t.integer "team_id"
    t.integer "assignment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "projects", force: :cascade do |t|
    t.integer "team_id"
    t.string "team_name"
    t.text "description"
    t.text "data_story"
    t.string "source_code_url"
    t.string "video_url"
    t.string "homepage_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
  end

  create_table "regions", force: :cascade do |t|
    t.string "name"
    t.string "time_zone"
    t.integer "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "registrations", force: :cascade do |t|
    t.integer "assignment_id"
    t.datetime "time_notified"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "event_id"
  end

  create_table "sponsors", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "website"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "competition_id"
  end

  create_table "sponsorship_types", force: :cascade do |t|
    t.integer "competition_id"
    t.string "name"
    t.integer "order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sponsorships", force: :cascade do |t|
    t.integer "sponsor_id"
    t.integer "sponsorship_type_id"
    t.string "sponsorable_type"
    t.integer "sponsorable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "approved", default: false
    t.index ["sponsorable_type", "sponsorable_id"], name: "index_sponsorships_on_sponsorable_type_and_sponsorable_id"
  end

  create_table "team_data_sets", force: :cascade do |t|
    t.integer "team_id"
    t.string "name"
    t.text "description"
    t.text "description_of_use"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "teams", force: :cascade do |t|
    t.integer "event_id"
    t.integer "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "published", default: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "full_name", default: "", null: false
    t.string "preferred_name"
    t.string "preferred_img"
    t.string "google_img"
    t.text "dietary_requirements"
    t.string "tshirt_size"
    t.string "twitter"
    t.boolean "mailing_list", default: false
    t.boolean "challenge_sponsor_contact_place", default: false
    t.boolean "challenge_sponsor_contact_enter", default: false
    t.boolean "my_project_sponsor_contact", default: false
    t.boolean "me_govhack_contact", default: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "organisation_name"
    t.string "phone_number"
    t.text "how_did_you_hear"
    t.boolean "accepted_terms_and_conditions", default: false
    t.string "registration_type"
    t.string "parent_guardian"
    t.boolean "request_not_photographed", default: false
    t.boolean "data_cruncher", default: false
    t.boolean "coder", default: false
    t.boolean "creative", default: false
    t.boolean "facilitator", default: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

end
