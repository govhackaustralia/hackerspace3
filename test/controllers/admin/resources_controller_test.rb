require 'test_helper'

class Admin::ResourcesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
    @resource = resources(:one)
    @competition = competitions(:one)
  end

  test 'should authenticate user' do
    sign_out users(:one)
    get admin_competition_resources_path @competition
    assert_redirected_to new_user_session_path
  end

  test 'should authorise user' do
    sign_out users(:one)
    sign_in users(:two)
    get admin_competition_resources_path @competition
    assert_redirected_to root_path
  end

  test 'should get index' do
    get admin_competition_resources_path @competition
    assert_response :success
  end

  test 'should get new' do
    get new_admin_competition_resource_path @competition
    assert_response :success
  end

  test 'should post create success' do
    assert_difference 'Resource.count' do
      post admin_competition_resources_path(
        @competition, params: {
          resource: {
            name: 'Example',
            category: 'data_portal',
            position: 1,
            url: 'www.example.com',
            short_url: 'example.short'
          }
        }
      )
    end
    assert_redirected_to admin_competition_resources_path @competition
  end

  test 'should post create fail' do
    assert_no_difference 'Resource.count' do
      post admin_competition_resources_path(
        @competition, params: {
          resource: { name: 'Example', position: nil }
        }
      )
    end
    assert_response :success
  end

  test 'should get edit' do
    get edit_admin_competition_resource_path(
      @competition, @resource
    )
    assert_response :success
  end

  test 'should patch update success' do
    patch admin_competition_resource_path(
      @competition, @resource, params: {
        resource: { name: 'Updated' }
      }
    )
    assert_redirected_to admin_competition_resources_path @competition
    @resource.reload
    assert @resource.name == 'Updated'
  end

  test 'should patch update fail' do
    patch admin_competition_resource_path(
      @competition, @resource, params: {
        resource: { name: nil }
      }
    )
    assert_response :success
    @resource.reload
    assert_not_nil @resource.name
  end

  test 'should delete destroy' do
    assert_difference 'Resource.count', -1 do
      delete admin_competition_resource_path(@competition, @resource)
    end
    assert_redirected_to admin_competition_resources_path @competition
  end
end
