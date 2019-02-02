require 'test_helper'

class Admin::Challenges::EntriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users :one
    @challenge = Challenge.first
    @entry = Entry.first
  end

  test 'should get index' do
    get admin_challenge_entries_url @challenge
    assert_response :success
  end

  test 'should get edit' do
    get edit_admin_challenge_entry_url @challenge, @entry
    assert_response :success
  end

  test 'should patch update success' do
    award = AWARD_NAMES.sample
    patch admin_challenge_entry_url @challenge, @entry, params: { entry: { award: award } }
    assert_redirected_to admin_challenge_entries_path @challenge
    @entry.reload
    assert @entry.award == award
  end

  test 'should patch update fail' do
    award = 'Test'
    patch admin_challenge_entry_url @challenge, @entry, params: { entry: { award: award } }
    assert_response :success
    @entry.reload
    assert_not @entry.award == award
  end
end
