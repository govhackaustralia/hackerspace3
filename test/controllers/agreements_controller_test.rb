# frozen_string_literal: true

require 'test_helper'

class AgreementsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
    @user = users(:one)
    @user.update(accepted_terms_and_conditions: nil)
  end

  test 'should get edit' do
    get review_terms_and_conditions_path
    assert_response :success
  end

  test 'should patch update success' do
    patch agreement_path(@user), params: {user: {
      accepted_terms_and_conditions: true, terms_and_conditions: '',
    }}
    assert_redirected_to complete_registration_path
    @user.reload
    assert @user.accepted_terms_and_conditions.present?
  end

  test 'should patch update fail' do
    patch agreement_path(@user), params: {user: {
      accepted_terms_and_conditions: false, terms_and_conditions: '',
    }}
    assert_redirected_to review_terms_and_conditions_path
    @user.reload
    assert @user.accepted_terms_and_conditions.nil?
  end

  # Tried to write the below test but was not working
  # test 'should patch update repel robot!' do
  #   patch agreement_path(@user), params: { user: {
  #     accepted_terms_and_conditions: true, terms_and_conditions: 'obey!'
  #   }}
  #   assert_response :success
  #   @user.reload
  #   assert @user.accepted_terms_and_conditions.nil?
  # end
end
