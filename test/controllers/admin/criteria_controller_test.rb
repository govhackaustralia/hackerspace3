# frozen_string_literal: true

require 'test_helper'

class Admin::CriteriaControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
    @competition = competitions(:one)
    @criterion = criteria(:one)
  end

  test 'should get index' do
    get admin_competition_criteria_url @competition
    assert_response :success
  end

  test 'should get new' do
    get new_admin_competition_criterion_url @competition
    assert_response :success
  end

  test 'should post create success' do
    assert_difference 'Criterion.count' do
      post admin_competition_criteria_url @competition, params: {criterion: {category: JUDGEMENT_CATEGORIES.sample, name: 'Fun Criterion', description: 'Lorem Ipsum'}}
    end
    assert_redirected_to admin_competition_criteria_url @competition
  end

  test 'should post create fail' do
    assert_no_difference 'Criterion.count' do
      post admin_competition_criteria_url @competition, params: {criterion: {category: 'Test', name: 'Fun Criterion', description: 'Lorem Ipsum'}}
    end
    assert_response :success
  end

  test 'should get edit' do
    get edit_admin_competition_criterion_path @competition, @criterion
    assert_response :success
  end

  test 'should patch update' do
    patch admin_competition_criterion_url @competition, @criterion, params: {criterion: {name: 'Updated', description: 'Lorem Ipsum'}}
    assert_redirected_to admin_competition_criteria_url @competition
    @criterion.reload
    assert @criterion.name == 'Updated'
  end
end
