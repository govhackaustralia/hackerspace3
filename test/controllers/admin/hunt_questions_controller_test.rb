# frozen_string_literal: true

require 'test_helper'

class Admin::HuntQuestionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
    @competition = competitions(:one)
    @hunt_question = hunt_questions(:one)
  end

  test 'should get index' do
    get admin_competition_hunt_questions_url(@competition)
    assert_response :success
  end

  test 'should get new' do
    get new_admin_competition_hunt_question_url(@competition)
    assert_response :success
  end

  test 'should post create success' do
    assert_difference('HuntQuestion.count') do
      post admin_competition_hunt_questions_url(@competition), params: {
        hunt_question: {
          question: 'one',
          answer: 'two'
        }
      }
    end
    assert_redirected_to admin_competition_hunt_questions_url(@competition)
  end

  test 'should post create fail' do
    assert_no_difference('HuntQuestion.count') do
      post admin_competition_hunt_questions_url(@competition), params: {
        hunt_question: {
          question: 'one'
        }
      }
    end
    assert_response :success
  end

  test 'should get edit' do
    get edit_admin_competition_hunt_question_url(@competition, @hunt_question)
    assert_response :success
  end

  test 'should patch update success' do
    patch admin_competition_hunt_question_url(@competition, @hunt_question), params: {
      hunt_question: { question: 'updated' }
    }
    assert_redirected_to admin_competition_hunt_questions_url(@competition)
    @hunt_question.reload
    assert @hunt_question.question == 'updated'
  end

  test 'should patch badge' do
    patch badge_admin_competition_hunt_questions_url(@competition, params: {
      competition: {hunt_badge_id: badges(:two).id}
    })
    @competition.reload
    assert @competition.hunt_badge == badges(:two)
  end

  test 'should publish the treasure hunt' do
    patch hunt_published_admin_competition_hunt_questions_url(@competition, params: {
      competition: {hunt_published: true}
    })
    @competition.reload
    assert @competition.hunt_published
  end
end
