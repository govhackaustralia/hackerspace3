require 'test_helper'

class Admin::SponsorshipTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
    @sponsorship_type = SponsorshipType.first
  end

  test 'should get index' do
    get admin_sponsorship_types_url
    assert_response :success
  end

  test 'should get new' do
    get new_admin_sponsorship_type_url
    assert_response :success
  end

  test 'should post create success' do
    assert_difference 'SponsorshipType.count' do
      post admin_sponsorship_types_url params: { sponsorship_type: { name: 'Example', order: 1 } }
    end
    assert_redirected_to admin_sponsorship_types_url
  end

  test 'should post create fail' do
    assert_no_difference 'SponsorshipType.count' do
      post admin_sponsorship_types_url params: { sponsorship_type: { name: 'Example', order: nil } }
    end
    assert_response :success
  end

  test 'should get edit' do
    get edit_admin_sponsorship_type_url @sponsorship_type
    assert_response :success
  end

  test 'should patch update success' do
    patch admin_sponsorship_type_url @sponsorship_type, params: { sponsorship_type: { name: 'Updated' } }
    assert_redirected_to admin_sponsorship_types_url
    @sponsorship_type.reload
    assert @sponsorship_type.name == 'Updated'
  end

  test 'should patch update fail' do
    patch admin_sponsorship_type_url @sponsorship_type, params: { sponsorship_type: { name: nil } }
    assert_response :success
    @sponsorship_type.reload
    assert_not_nil @sponsorship_type.name
  end
end
