require 'test_helper'

class HuntQuestionTest < ActiveSupport::TestCase
  setup do
    @competition = competitions :one
    @hunt_question = hunt_questions :one
  end

  test 'associatons' do
    assert @hunt_question.competition == @competition
  end

  test 'validations' do
    assert_not @hunt_question.update(question: nil)
    assert_not @hunt_question.update(answer: nil)
  end
end
