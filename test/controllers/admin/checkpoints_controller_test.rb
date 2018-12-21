require 'test_helper'

class Admin::CheckpointsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
    @competition = Competition.first
    @checkpoint = Checkpoint.first
  end

  test 'should get index' do
    get admin_competition_checkpoints_url(@competition)
    assert_response :success
  end

  test 'should get new' do
    get new_admin_competition_checkpoint_url(@competition)
    assert_response :success
  end

  test 'should post create success' do
    assert_difference('Checkpoint.count') do
      post admin_competition_checkpoints_url(@competition), params: { checkpoint: { name: 'Fun Checkpoint', end_time: Time.now + 1.week, max_national_challenges: 2, max_regional_challenges: 2 } }
    end
    assert_redirected_to admin_competition_checkpoints_url(@competition)
  end

  test 'should post create fail' do
    assert_no_difference('Checkpoint.count') do
      post admin_competition_checkpoints_url(@competition), params: { checkpoint: { name: nil, end_time: Time.now + 1.week, max_national_challenges: 2, max_regional_challenges: 2 } }
    end
    assert_response :success
  end

  test 'should get edit' do
    get edit_admin_competition_checkpoint_url(@competition, @checkpoint)
    assert_response :success
  end

  test 'should patch update success' do
    patch admin_competition_checkpoint_url(@competition, @checkpoint), params: { checkpoint: { name: 'updated' } }
    assert_redirected_to admin_competition_checkpoints_url(@competition)
    @checkpoint.reload
    assert @checkpoint.name == 'updated'
  end
end
