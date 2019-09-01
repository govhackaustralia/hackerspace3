require 'test_helper'

class TeamManagement::EntriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users :two
    @team = Team.first
    @challenge = Challenge.third
    @checkpoint = Checkpoint.first
    @entry = Entry.first
  end

  test 'should get index' do
    get team_management_team_entries_url @team
    assert_response :success
  end

  test 'should get new' do
    get new_team_management_team_entry_url @team, challenge_id: @challenge.id
    assert_response :success
  end

  test 'should post create success' do
    Entry.destroy_all
    assert_difference 'Entry.count' do
      post team_management_team_entries_url @team, params: { entry: {
        checkpoint_id: @checkpoint.id, challenge_id: @challenge.id,
        justification: 'Test'
      } }
    end
    assert_redirected_to challenge_path(Entry.last.challenge.identifier)
  end

  test 'should post create fail' do
    Entry.destroy_all
    assert_no_difference 'Entry.count' do
      post team_management_team_entries_url @team, params: { entry: {
        checkpoint_id: @checkpoint.id, challenge_id: @challenge.id,
        justification: nil
      } }
    end
    assert_response :success
  end

  test 'should get edit' do
    get edit_team_management_team_entry_url @team, @entry
    assert_response :success
  end

  test 'should patch update success' do
    patch team_management_team_entry_url @team, @entry, params: { entry: {
      justification: 'Updated', checkpoint_id: @checkpoint.id
    } }
    assert_redirected_to team_management_team_entries_path @team
    @entry.reload
    assert @entry.justification == 'Updated'
  end

  test 'should patch update fail' do
    patch team_management_team_entry_url @team, @entry, params: { entry: {
      justification: nil, checkpoint_id: @checkpoint.id
    } }
    assert_response :success
    @entry.reload
    assert_not @entry.justification.nil?
  end

  test 'should delete destroy' do
    assert_difference 'Entry.count', -1 do
      delete team_management_team_entry_url @team, @entry
    end
    assert_redirected_to team_management_team_entries_url @team
  end
end
