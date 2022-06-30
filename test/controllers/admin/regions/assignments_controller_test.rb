require 'test_helper'

class Admin::Regions::AssignmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
    @region = Region.first
    @user = users(:one)
  end

  test 'should get index' do
    get admin_region_assignments_url @region
    assert_response :success
  end

  test 'should get new' do
    get new_admin_region_assignment_url @region, title: REGION_DIRECTOR
    assert_response :success
    get new_admin_region_assignment_url @region, title: REGION_DIRECTOR, term: 'x'
    assert_response :success
    get new_admin_region_assignment_url @region, title: REGION_DIRECTOR, term: 'a'
    assert_response :success
  end

  test 'should post create success' do
    assignments(:region_director).destroy!
    assert_difference 'Assignment.count', 1 do
      post admin_region_assignments_url @region, params: { title: REGION_DIRECTOR, user_id: @user }
    end
    assert_redirected_to admin_region_assignments_url @region
  end

  test 'should post create fail' do
    assert_no_difference 'Assignment.count' do
      post admin_region_assignments_url @region, params: { title: REGION_DIRECTOR, user_id: nil }
    end
    assert_response :success
  end
end
