require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  setup do
    @team = Team.first
    @project = Project.first
  end

  test 'project associations' do
    assert(@project.team == @team)
  end

  test 'project validations' do
    assert_not(@team.projects.new.save)
  end
end
