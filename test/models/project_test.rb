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
require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  setup do
    @project = projects(:one)
    @team = teams(:one)
    @user = users(:one)
    @event = events(:competition)
  end

  test 'project associations' do
    assert @project.team == @team
    assert @project.user == @user
    assert @project.event == @event
    assert @project.competition == competitions(:one)
  end

  test 'project scopes' do
    assert Project.search('A').include? @project
    assert Project.search('x').include? @project
  end

  test 'project validations' do
    assert_not @project.update team_name: nil
    assert_not @project.update project_name: nil
  end

  test 'update_team_current_project' do
    project = @team.projects.create!(
      team_name: 'new name',
      project_name: 'new_name',
      user: @user
    )
    @team.reload
    assert @team.current_project == project
  end

  test 'strip_team_and_project_name' do
    projects(:one).update! project_name: '  project name ', team_name: '   team name  '

    projects(:one).reload

    assert_equal 'project name', projects(:one).project_name
    assert_equal 'team name', projects(:one).team_name
  end

  test 'update identifier saves identifier despite no url save characters' do
    assert_not_equal @project.id, @project.identifier
    @project.update! project_name: '...'
    @project.reload
    assert_equal @project.id.to_s, @project.identifier
  end
end
