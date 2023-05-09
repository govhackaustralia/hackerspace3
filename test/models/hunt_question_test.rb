# == Schema Information
#
# Table name: hunt_questions
#
#  id             :bigint           not null, primary key
#  competition_id :integer
#  question       :string
#  answer         :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
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
