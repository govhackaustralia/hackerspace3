require 'test_helper'

class Admin::RegionLimitsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
    @checkpoint = checkpoints(:one)
    @region_limit = region_limits(:one)
    @competition = competitions(:one)
  end

  test 'should get new' do
    get new_admin_checkpoint_region_limit_url @checkpoint
    assert_response :success
  end

  test 'should post create success' do
    assert_difference('RegionLimit.count') do
      post admin_checkpoint_region_limits_url(@checkpoint), params: {
        region_limit: {
          region_id: 2,
          max_national_challenges: 2,
          max_regional_challenges: 2
        }
      }
    end
    assert_redirected_to admin_competition_checkpoints_url @competition
  end

  test 'should post create fail' do
    assert_no_difference('RegionLimit.count') do
      post admin_checkpoint_region_limits_url(@checkpoint), params: {
        region_limit: {
          max_national_challenges: 2,
          max_regional_challenges: 2
        }
      }
    end
    assert_response :success
  end

  test 'should get edit' do
    get edit_admin_checkpoint_region_limit_url @checkpoint, @region_limit
    assert_response :success
  end

  test 'should patch update success' do
    patch admin_checkpoint_region_limit_url(@checkpoint, @region_limit),
          params: { region_limit: { max_national_challenges: 5 } }
    assert_redirected_to admin_competition_checkpoints_url @competition
    @region_limit.reload
    assert @region_limit.max_national_challenges == 5
  end
end
