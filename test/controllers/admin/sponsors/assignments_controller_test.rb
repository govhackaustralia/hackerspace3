# frozen_string_literal: true

require 'test_helper'

class Admin::Sponsors::AssignmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
    @sponsor = sponsors(:one)
    @user = users(:one)
  end

  test 'should get new' do
    get new_admin_sponsor_assignment_url @sponsor, title: SPONSOR_CONTACT
    assert_response :success
    get new_admin_sponsor_assignment_url(
      @sponsor, title: SPONSOR_CONTACT, term: 'x'
    )
    assert_response :success
    get new_admin_sponsor_assignment_url(
      @sponsor, title: SPONSOR_CONTACT, term: 'a'
    )
    assert_response :success
  end

  test 'should post create success' do
    assignments(:sponsor_contact).destroy!
    assert_difference 'Assignment.count', 1 do
      post admin_sponsor_assignments_url @sponsor, params: {
        title: SPONSOR_CONTACT, user_id: @user,
      }
    end
    assert_redirected_to admin_competition_sponsor_url(
      @sponsor.competition_id, @sponsor
    )
  end

  test 'should post create fail' do
    assert_no_difference 'Assignment.count' do
      post admin_sponsor_assignments_url @sponsor, params: {
        title: SPONSOR_CONTACT, user_id: nil,
      }
    end
    assert_response :success
  end
end
