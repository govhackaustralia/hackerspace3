# frozen_string_literal: true

# == Schema Information
#
# Table name: projects
#
#  id              :bigint           not null, primary key
#  data_story      :text
#  description     :text
#  homepage_url    :string
#  identifier      :string
#  project_name    :string
#  source_code_url :string
#  team_name       :string
#  video_url       :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  team_id         :integer
#  user_id         :integer
#
# Indexes
#
#  index_projects_on_identifier  (identifier)
#  index_projects_on_team_id     (team_id)
#  index_projects_on_user_id     (user_id)
#
FactoryBot.define do
  factory :project do
    description { 'Default Description' }
    team_name { 'Team #1' }
  end
end
