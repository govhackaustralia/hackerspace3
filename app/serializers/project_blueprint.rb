# frozen_string_literal: true

class ProjectBlueprint < Blueprinter::Base
  identifier :id
  fields :project_name, :team_id, :team_name, :data_story, :description, :homepage_url, :identifier, :source_code_url, :video_url, :created_at, :updated_at, :user_id
end
