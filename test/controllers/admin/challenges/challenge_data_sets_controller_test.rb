require 'test_helper'

class Admin::Challenges::ChallengeDataSetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
  end

  test 'should get new' do
    get new__url
    assert_response :success
  end
  #
  # test 'should post create' do
  #   assert_difference('Group.count') do
  #     post groups_url params: { group: { name: 'Fun Group' } }
  #   end
  #   assert_redirected_to group_path(Group.last)
  # end
  #
  # test 'should delete destroy' do
  #   assert_difference('Support.count', -1) do
  #     delete position_support_url(@position, @support)
  #   end
  #   assert_redirected_to group_issue_url(@group, @issue)
  # end
end
