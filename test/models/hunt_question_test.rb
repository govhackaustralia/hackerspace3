require 'test_helper'

class HuntQuestionTest < ActiveSupport::TestCase
  setup do
    @competition = competitions :one
    @hunt_question = hunt_questions :one
  end

  test 'associatons' do
    assert @hunt_question.competition == @competition
  end
end
