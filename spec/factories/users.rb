# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                              :bigint           not null, primary key
#  accepted_code_of_conduct        :datetime
#  accepted_terms_and_conditions   :boolean
#  challenge_sponsor_contact_enter :boolean          default(FALSE)
#  challenge_sponsor_contact_place :boolean          default(FALSE)
#  coder                           :boolean          default(FALSE)
#  confirmation_sent_at            :datetime
#  confirmation_token              :string
#  confirmed_at                    :datetime
#  creative                        :boolean          default(FALSE)
#  current_sign_in_at              :datetime
#  current_sign_in_ip              :inet
#  data_cruncher                   :boolean          default(FALSE)
#  dietary_requirements            :text
#  email                           :string           default(""), not null
#  encrypted_password              :string           default(""), not null
#  facilitator                     :boolean          default(FALSE)
#  failed_attempts                 :integer          default(0), not null
#  full_name                       :string           default(""), not null
#  google_img                      :string
#  how_did_you_hear                :text
#  last_sign_in_at                 :datetime
#  last_sign_in_ip                 :inet
#  locked_at                       :datetime
#  mailing_list                    :boolean          default(FALSE)
#  me_govhack_contact              :boolean          default(FALSE)
#  my_project_sponsor_contact      :boolean          default(FALSE)
#  organisation_name               :string
#  parent_guardian                 :string
#  phone_number                    :string
#  preferred_img                   :string
#  preferred_name                  :string
#  region                          :integer
#  registration_type               :string
#  remember_created_at             :datetime
#  request_not_photographed        :boolean          default(FALSE)
#  reset_password_sent_at          :datetime
#  reset_password_token            :string
#  sign_in_count                   :integer          default(0), not null
#  slack                           :string
#  tshirt_size                     :string
#  unconfirmed_email               :string
#  under_18                        :boolean
#  unlock_token                    :string
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#  acting_on_behalf_of_id          :integer
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_region                (region)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_under_18              (under_18)
#  index_users_on_unlock_token          (unlock_token) UNIQUE
#
FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user_#{n}@example.com" }
    password { 'password' }
    confirmed_at { Time.now }
  end
end
