# frozen_string_literal: true

require 'test_helper'

class Admin::TeamsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
    @team = teams(:one)
    @project = projects(:two)
    @competition = @team.competition
  end

  test 'should get index' do
    get admin_competition_teams_url @competition
    assert_response :success
  end

  test 'should get all members to csv' do
    get admin_competition_teams_url @competition, format: :csv, category: :members
    assert_response :success
  end

  test 'should get teams entry report csv' do
    get admin_competition_teams_url @competition, format: :csv, category: :entries
    assert_response :success
  end

  test 'should get published teams to csv' do
    get admin_competition_teams_url @competition, format: :csv
    assert_response :success
  end

  test 'should get show' do
    get admin_competition_team_url @competition, @team
    assert_response :success
  end

  test 'should patch update project' do
    patch update_version_admin_competition_team_path(
      @competition, @team, params: {project_id: @project.id},
    )
    assert_redirected_to admin_team_project_url @team, @project
    @team.reload
    assert @team.current_project == @project
  end

  test 'should patch update published' do
    patch update_published_admin_competition_team_path(
      @competition, @team, params: {published: false},
    )
    assert_redirected_to admin_competition_team_url @competition, @team
    @team.reload
    assert_not @team.published
  end
end
