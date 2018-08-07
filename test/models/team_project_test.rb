require 'test_helper'

class TeamProjectTest < ActiveSupport::TestCase
  setup do
    @team_project = TeamProject.first
    @team_project_version = TeamProjectVersion.first
    @event = Event.first
  end

  test 'team project associations' do
    assert(@team_project.current_version == @team_project_version)
    assert(@team_project.event == @event)
    @team_project.destroy
    assert(TeamProjectVersion.find_by(team_project: @team_project).nil?)
  end

  test 'change_event' do
    @second_event = Event.second
    @team_project.change_event(@second_event)
  end
end
