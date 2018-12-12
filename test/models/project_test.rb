require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  setup do
    @project = Project.first
    @team = Team.first
    @user = User.first
  end

  test 'project associations' do
    assert @project.team == @team
    assert @project.user == @user
  end

  test 'project validations' do
    assert_not @project.update team_name: nil
    assert_not @project.update project_name: nil
  end
end
