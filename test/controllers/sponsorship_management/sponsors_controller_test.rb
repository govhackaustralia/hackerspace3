# frozen_string_literal: true

require 'test_helper'

class SponsorshipManagement::SponsorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
    @sponsor = sponsors(:one)
  end

  test 'should get show' do
    get sponsorship_management_sponsor_url @sponsor
    assert_response :success
  end

  test 'should get edit' do
    get edit_sponsorship_management_sponsor_url @sponsor
    assert_response :success
  end

  test 'should patch update success' do
    patch sponsorship_management_sponsor_url @sponsor, params: {
      sponsor: {description: 'Updated'},
    }
    assert_redirected_to sponsorship_management_sponsor_url @sponsor
    @sponsor.reload
    assert @sponsor.description == 'Updated'
  end

  test 'should patch update fail' do
    patch sponsorship_management_sponsor_url @sponsor, params: {
      sponsor: {name: nil},
    }
    assert_response :success
    @sponsor.reload
    assert_not @sponsor.name.nil?
  end
end
