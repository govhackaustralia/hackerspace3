# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_05_08_043709) do

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
    t.integer "competition_id"
    t.integer "holder_id"
    t.index ["assignable_type", "assignable_id"], name: "index_assignments_on_assignable_type_and_assignable_id"
    t.index ["competition_id"], name: "index_assignments_on_competition_id"
    t.index ["holder_id"], name: "index_assignments_on_holder_id"
    t.index ["title"], name: "index_assignments_on_title"
    t.index ["user_id"], name: "index_assignments_on_user_id"
  end

  create_table "bulk_mails", force: :cascade do |t|
    t.integer "user_id"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "status"
    t.string "from_email"
    t.string "subject"
    t.string "mailable_type"
    t.integer "mailable_id"
    t.index ["mailable_type", "mailable_id"], name: "index_bulk_mails_on_mailable_type_and_mailable_id"
    t.index ["user_id"], name: "index_bulk_mails_on_user_id"
  end

  create_table "challenge_data_sets", force: :cascade do |t|
    t.integer "challenge_id"
    t.integer "data_set_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["challenge_id"], name: "index_challenge_data_sets_on_challenge_id"
    t.index ["data_set_id"], name: "index_challenge_data_sets_on_data_set_id"
  end

  create_table "challenge_sponsorships", force: :cascade do |t|
    t.integer "challenge_id"
    t.integer "sponsor_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "approved", default: false
    t.index ["challenge_id"], name: "index_challenge_sponsorships_on_challenge_id"
    t.index ["sponsor_id"], name: "index_challenge_sponsorships_on_sponsor_id"
  end

  create_table "challenges", force: :cascade do |t|
    t.integer "region_id"
    t.string "name"
    t.text "short_desc"
    t.text "long_desc"
    t.text "eligibility"
    t.string "video_url"
    t.boolean "approved", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "identifier"
    t.boolean "nation_wide"
    t.index ["approved"], name: "index_challenges_on_approved"
    t.index ["identifier"], name: "index_challenges_on_identifier"
    t.index ["nation_wide"], name: "index_challenges_on_nation_wide"
    t.index ["region_id"], name: "index_challenges_on_region_id"
  end

  create_table "checkpoints", force: :cascade do |t|
    t.integer "competition_id"
    t.datetime "end_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "max_regional_challenges"
    t.integer "max_national_challenges"
    t.string "name"
    t.index ["competition_id"], name: "index_checkpoints_on_competition_id"
  end

  create_table "competitions", force: :cascade do |t|
    t.integer "year"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "peoples_choice_start"
    t.datetime "peoples_choice_end"
    t.datetime "challenge_judging_start"
    t.datetime "challenge_judging_end"
    t.boolean "current"
    t.datetime "team_form_start"
    t.datetime "team_form_end"
    t.index ["current"], name: "index_competitions_on_current"
    t.index ["year"], name: "index_competitions_on_year"
  end

  create_table "correspondences", force: :cascade do |t|
    t.integer "user_id"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "body"
    t.string "orderable_type"
    t.integer "orderable_id"
    t.index ["orderable_type", "orderable_id"], name: "index_correspondences_on_orderable_type_and_orderable_id"
    t.index ["status"], name: "index_correspondences_on_status"
    t.index ["user_id"], name: "index_correspondences_on_user_id"
  end

  create_table "criteria", force: :cascade do |t|
    t.integer "competition_id"
    t.text "description"
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.index ["competition_id"], name: "index_criteria_on_competition_id"
  end

  create_table "data_sets", force: :cascade do |t|
    t.integer "region_id"
    t.string "name"
    t.string "url"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["region_id"], name: "index_data_sets_on_region_id"
  end

  create_table "entries", force: :cascade do |t|
    t.integer "team_id"
    t.integer "challenge_id"
    t.integer "checkpoint_id"
    t.text "justification"
    t.boolean "eligible"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "award"
    t.index ["award"], name: "index_entries_on_award"
    t.index ["challenge_id"], name: "index_entries_on_challenge_id"
    t.index ["checkpoint_id"], name: "index_entries_on_checkpoint_id"
    t.index ["eligible"], name: "index_entries_on_eligible"
    t.index ["team_id"], name: "index_entries_on_team_id"
  end

  create_table "event_partnerships", force: :cascade do |t|
    t.integer "event_id"
    t.integer "sponsor_id"
    t.boolean "approved", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["approved"], name: "index_event_partnerships_on_approved"
    t.index ["event_id"], name: "index_event_partnerships_on_event_id"
    t.index ["sponsor_id"], name: "index_event_partnerships_on_sponsor_id"
  end

  create_table "events", force: :cascade do |t|
    t.integer "region_id"
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
    t.boolean "published", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "place_id"
    t.string "identifier"
    t.string "event_type"
    t.text "description"
    t.index ["identifier"], name: "index_events_on_identifier"
    t.index ["published"], name: "index_events_on_published"
    t.index ["region_id"], name: "index_events_on_region_id"
  end

  create_table "favourites", force: :cascade do |t|
    t.integer "assignment_id"
    t.integer "team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "holder_id"
    t.index ["assignment_id"], name: "index_favourites_on_assignment_id"
    t.index ["holder_id"], name: "index_favourites_on_holder_id"
    t.index ["team_id"], name: "index_favourites_on_team_id"
  end

  create_table "flights", force: :cascade do |t|
    t.integer "event_id"
    t.string "description"
    t.string "direction"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "headers", force: :cascade do |t|
    t.integer "assignment_id"
    t.string "scoreable_type"
    t.bigint "scoreable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "included", default: true
    t.index ["assignment_id"], name: "index_headers_on_assignment_id"
    t.index ["included"], name: "index_headers_on_included"
    t.index ["scoreable_type", "scoreable_id"], name: "index_headers_on_scoreable_type_and_scoreable_id"
  end

  create_table "holders", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "competition_id", null: false
    t.boolean "aws_credits_requested"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["aws_credits_requested"], name: "index_holders_on_aws_credits_requested"
    t.index ["competition_id"], name: "index_holders_on_competition_id"
    t.index ["user_id"], name: "index_holders_on_user_id"
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
    t.string "project_name"
    t.string "identifier"
    t.index ["identifier"], name: "index_projects_on_identifier"
    t.index ["team_id"], name: "index_projects_on_team_id"
    t.index ["user_id"], name: "index_projects_on_user_id"
  end

  create_table "region_limits", force: :cascade do |t|
    t.integer "region_id"
    t.integer "checkpoint_id"
    t.integer "max_regional_challenges"
    t.integer "max_national_challenges"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["checkpoint_id"], name: "index_region_limits_on_checkpoint_id"
    t.index ["region_id"], name: "index_region_limits_on_region_id"
  end

  create_table "regions", force: :cascade do |t|
    t.string "name"
    t.string "time_zone"
    t.integer "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "award_release"
    t.integer "competition_id"
    t.string "category"
    t.index ["competition_id"], name: "index_regions_on_competition_id"
    t.index ["parent_id"], name: "index_regions_on_parent_id"
  end

  create_table "registration_flights", force: :cascade do |t|
    t.integer "registration_id"
    t.integer "flight_id"
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
    t.integer "holder_id"
    t.index ["assignment_id"], name: "index_registrations_on_assignment_id"
    t.index ["event_id"], name: "index_registrations_on_event_id"
    t.index ["holder_id"], name: "index_registrations_on_holder_id"
    t.index ["status"], name: "index_registrations_on_status"
  end

  create_table "scores", force: :cascade do |t|
    t.integer "header_id"
    t.integer "criterion_id"
    t.integer "entry"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["criterion_id"], name: "index_scores_on_criterion_id"
    t.index ["header_id"], name: "index_scores_on_header_id"
  end

  create_table "sponsors", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "website"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "competition_id"
    t.index ["competition_id"], name: "index_sponsors_on_competition_id"
  end

  create_table "sponsorship_types", force: :cascade do |t|
    t.integer "competition_id"
    t.string "name"
    t.integer "order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["competition_id"], name: "index_sponsorship_types_on_competition_id"
    t.index ["order"], name: "index_sponsorship_types_on_order"
  end

  create_table "sponsorships", force: :cascade do |t|
    t.integer "sponsor_id"
    t.integer "sponsorship_type_id"
    t.string "sponsorable_type"
    t.integer "sponsorable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "approved", default: false
    t.index ["approved"], name: "index_sponsorships_on_approved"
    t.index ["sponsor_id"], name: "index_sponsorships_on_sponsor_id"
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
    t.index ["team_id"], name: "index_team_data_sets_on_team_id"
  end

  create_table "team_orders", force: :cascade do |t|
    t.integer "bulk_mail_id"
    t.integer "team_id"
    t.string "request_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bulk_mail_id"], name: "index_team_orders_on_bulk_mail_id"
    t.index ["request_type"], name: "index_team_orders_on_request_type"
    t.index ["team_id"], name: "index_team_orders_on_team_id"
  end

  create_table "teams", force: :cascade do |t|
    t.integer "event_id"
    t.integer "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "published", default: true
    t.boolean "youth_team", default: false
    t.index ["event_id"], name: "index_teams_on_event_id"
    t.index ["project_id"], name: "index_teams_on_project_id"
    t.index ["published"], name: "index_teams_on_published"
  end

  create_table "user_orders", force: :cascade do |t|
    t.integer "bulk_mail_id"
    t.string "request_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bulk_mail_id"], name: "index_user_orders_on_bulk_mail_id"
    t.index ["request_type"], name: "index_user_orders_on_request_type"
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
    t.boolean "accepted_terms_and_conditions"
    t.string "registration_type"
    t.string "parent_guardian"
    t.boolean "request_not_photographed", default: false
    t.boolean "data_cruncher", default: false
    t.boolean "coder", default: false
    t.boolean "creative", default: false
    t.boolean "facilitator", default: false
    t.string "bsb"
    t.string "acc_number"
    t.string "acc_name"
    t.string "branch_name"
    t.string "slack"
    t.datetime "accepted_code_of_conduct"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "holders", "competitions"
  add_foreign_key "holders", "users"
end
