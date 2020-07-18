require 'test_helper'

class HuntQuestionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @hunt_question = hunt_questions(:one)
    sign_in users :one
  end

  test 'should get scavenger_hunt' do
    get scavenger_hunt_path
    assert_response :success
  end

  test 'should award question' do
    assert_difference 'Assignment.count', 1 do
      patch hunt_question_path(@hunt_question), params: {
        hunt_question: {
          answer: @hunt_question.answer
        }
      }
    end
    assert_redirected_to scavenger_hunt_path
    assert flash[:notice].present?
  end

  test 'should ask to try again' do
    assert_no_difference 'Assignment.count' do
      patch hunt_question_path(@hunt_question), params: {
        hunt_question: {
          answer: 'Wrong Answer'
        }
      }
    end
    assert_redirected_to scavenger_hunt_path
    assert flash[:alert].present?
  end
end
