require 'test_helper'

class Admin::SponsorLogosControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users :one
    @sponsor = Sponsor.first
  end

  test 'should get edit' do
    get edit_admin_sponsor_logo_url @sponsor
    assert_response :success
  end

  # ENHANCEMENT: Find way to test image upload.

  test 'should patch update fail' do
    patch admin_sponsor_logo_url @sponsor, params: {}
    assert_response :success
  end
end
