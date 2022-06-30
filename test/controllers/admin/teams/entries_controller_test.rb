require 'test_helper'

class Admin::Teams::EntriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
    @team = Team.first
    @entry = entries(:one)
    @challenge = challenges(:three)
    @checkpoint = Checkpoint.first
    @competition = @team.competition
  end

  test 'should get new' do
    get new_admin_team_entry_url @team
    assert_response :success
  end

  test 'should post create success' do
    Entry.destroy_all
    assert_difference 'Entry.count' do
      post admin_team_entries_url @team, params: { entry: {
        challenge_id: @challenge.id,
        checkpoint_id: @checkpoint.id,
        justification: 'Test'
      } }
    end
    assert_redirected_to admin_competition_team_url @competition, @team
  end

  test 'should post create fail' do
    assert_no_difference 'Entry.count' do
      post admin_team_entries_url @team, params: { entry: {
        challenge_id: @challenge.id,
        checkpoint_id: @checkpoint.id,
        justification: 'Test'
      } }
    end
    assert_response :success
  end

  test 'should get edit' do
    get edit_admin_team_entry_url @team, @entry
    assert_response :success
  end

  test 'should patch update success' do
    patch admin_team_entry_url @team, @entry, params: { entry: {
      justification: 'Updated'
    } }
    assert_redirected_to admin_competition_team_url @competition, @team
    @entry.reload
    assert @entry.justification == 'Updated'
  end

  test 'should patch update fail' do
    patch admin_team_entry_url @team, @entry, params: { entry: {
      checkpoint_id: nil
    } }
    assert_response :success
    @entry.reload
    assert_not @entry.justification.nil?
  end

  test 'should delete destroy' do
    assert_difference 'Entry.count', -1 do
      delete admin_team_entry_url @team, @entry
    end
    assert_redirected_to admin_competition_team_url @competition, @team
  end
end
