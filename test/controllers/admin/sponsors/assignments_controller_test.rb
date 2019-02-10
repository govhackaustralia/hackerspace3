require 'test_helper'

class Admin::Sponsors::AssignmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users :one
    @sponsor = Sponsor.first
    @user = User.first
  end

  test 'should get new' do
    get new_admin_sponsor_assignment_url @sponsor, title: SPONSOR_CONTACT
    assert_response :success
    get new_admin_sponsor_assignment_url @sponsor, title: SPONSOR_CONTACT, term: 'x'
    assert_response :success
    get new_admin_sponsor_assignment_url @sponsor, title: SPONSOR_CONTACT, term: 'a'
    assert_response :success
  end

  test 'should post create success' do
    assert_difference 'Assignment.count' do
      post admin_sponsor_assignments_url @sponsor, params: { title: SPONSOR_CONTACT, user_id: @user }
    end
    assert_redirected_to admin_sponsor_url @sponsor
  end

  test 'should post create fail' do
    assert_no_difference 'Assignment.count' do
      post admin_sponsor_assignments_url @sponsor, params: { title: SPONSOR_CONTACT, user_id: nil }
    end
    assert_response :success
  end
end
