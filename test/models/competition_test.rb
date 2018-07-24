require 'test_helper'

class CompetitionTest < ActiveSupport::TestCase
  setup do
    @competition = Competition.first
    @assignment = Assignment.first
    @event = Event.first
  end

  test 'competition associations' do
    assert(@competition.assignments.include?(@assignment))
    assert(@competition.events.include?(@event))
  end

  test 'competition validations' do
    @competition.destroy
    # No year
    competition = Competition.create
    assert_not(competition.persisted?)
  end
end
