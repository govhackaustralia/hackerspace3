require 'test_helper'

class TeamProjectVersionTest < ActiveSupport::TestCase
  setup do
    @team_project = TeamProject.first
    @team_project_version = TeamProjectVersion.first
  end

  test 'team project versions associations' do
    assert(@team_project_version.team_project == @team_project)
  end

  test 'team project versions validations' do
    assert_not(@team_project.team_project_versions.new.save)
  end
end
