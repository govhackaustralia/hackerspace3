require 'test_helper'

class Admin::SponsorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users :one
    @sponsor = Sponsor.first
  end

  test 'should get index' do
    get admin_sponsors_url
    assert_response :success
  end

  test 'should get show' do
    get admin_sponsor_url @sponsor
    assert_response :success
  end

  test 'should get new' do
    get new_admin_sponsor_url
    assert_response :success
  end

  test 'should post create success' do
    assert_difference 'Sponsor.count' do
      post admin_sponsors_url params: { sponsor: { name: 'Example', description: 'Example' } }
    end
    assert_redirected_to admin_sponsor_url Sponsor.last
  end

  test 'should post create fail' do
    assert_no_difference 'Sponsor.count' do
      post admin_sponsors_url params: { sponsor: { description: 'Example' } }
    end
    assert_response :success
  end

  test 'should get edit' do
    get edit_admin_sponsor_url @sponsor
    assert_response :success
  end

  test 'should patch update success' do
    patch admin_sponsor_url @sponsor, params: { sponsor: { description: 'Updated' } }
    assert_redirected_to admin_sponsor_url @sponsor
    @sponsor.reload
    assert @sponsor.description == 'Updated'
  end

  test 'should patch update fail' do
    patch admin_sponsor_url @sponsor, params: { sponsor: { name: nil } }
    assert_response :success
    @sponsor.reload
    assert_not @sponsor.name.nil?
  end

  test 'should delete destroy' do
    assert_difference 'Sponsor.count', -1 do
      delete admin_sponsor_url @sponsor
    end
    assert_redirected_to admin_sponsors_url
  end
end
