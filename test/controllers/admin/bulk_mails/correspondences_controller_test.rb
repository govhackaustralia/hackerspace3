require 'test_helper'

class Admin::BulkMails::CorrespondencesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users :one
    @correspondence = Correspondence.first
    @bulk_mail = BulkMail.first
  end

  test 'should get show' do
    get admin_bulk_mail_correspondence_url @bulk_mail, @correspondence
    assert_response :success
  end
end
