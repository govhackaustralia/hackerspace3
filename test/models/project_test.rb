require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  setup do
    @project = Project.first
    @team = Team.first
    @user = User.first
    @event = Event.second
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

  test 'update identifier saves identifier despite no url save characters' do
    assert_not_equal '1', @project.identifier
    @project.update! project_name: '...'
    @project.reload
    assert_equal '1', @project.identifier
  end
end
