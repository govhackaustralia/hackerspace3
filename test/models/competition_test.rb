require 'test_helper'

class CompetitionTest < ActiveSupport::TestCase
  setup do
    @competition = Competition.find(1)
    @assignment = Assignment.find(1)
  end

  test 'competition associations' do
    assert(@competition.assignments.include?(@assignment))
  end

  test 'competition validations' do
    @competition.destroy
    # No year
    competition = Competition.create
    assert_not(competition.persisted?)
  end
end
