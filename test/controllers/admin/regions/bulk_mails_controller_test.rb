require 'test_helper'

class Admin::Regions::BulkMailsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users :one
    @region = Region.first
    @bulk_mail = BulkMail.first
  end

  test 'should get index' do
    get admin_region_bulk_mails_url @region
    assert_response :success
  end

  test 'should get show' do
    get admin_region_bulk_mail_url @region, @bulk_mail
    assert_response :success
  end

  test 'should get new' do
    get new_admin_region_bulk_mail_url @region
    assert_response :success
  end

  test 'should post create success' do
    assert_difference 'BulkMail.count' do
      post admin_region_bulk_mails_url @region, params: { bulk_mail: { name: 'Test', from_email: 'email@example.com', subject: 'Test', body: 'Test' } }
    end
    assert_redirected_to admin_region_bulk_mail_url @region, BulkMail.last
  end

  test 'should post create fail' do
    assert_no_difference 'BulkMail.count' do
      post admin_region_bulk_mails_url @region, params: { bulk_mail: { name: nil, from_email: 'email@example.com', subject: 'Test', body: 'Test' } }
    end
    assert_response :success
  end

  test 'should get edit' do
    get edit_admin_region_bulk_mail_url @region, @bulk_mail
    assert_response :success
  end

  test 'should patch update success' do
    patch admin_region_bulk_mail_url @region, @bulk_mail, params: { bulk_mail: { name: 'Updated' } }
    assert_redirected_to admin_region_bulk_mail_url @region, @bulk_mail
    @bulk_mail.reload
    assert @bulk_mail.name == 'Updated'
  end

  test 'should patch update fail' do
    patch admin_region_bulk_mail_url @region, @bulk_mail, params: { bulk_mail: { name: 'Updated', from_email: nil } }
    assert_response :success
    @bulk_mail.reload
    assert_not @bulk_mail.name == 'Updated'
  end
end
