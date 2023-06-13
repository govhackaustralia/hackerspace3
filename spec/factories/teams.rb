# frozen_string_literal: true

# == Schema Information
#
# Table name: teams
#
#  id                 :bigint           not null, primary key
#  published          :boolean          default(TRUE)
#  slack_channel_name :string
#  youth_team         :boolean          default(FALSE)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  event_id           :integer
#  project_id         :integer
#  slack_channel_id   :string
#
# Indexes
#
#  index_teams_on_event_id    (event_id)
#  index_teams_on_project_id  (project_id)
#  index_teams_on_published   (published)
#
FactoryBot.define do
  factory :team do
    slack_channel_name { 'My Team' }
  end
end
