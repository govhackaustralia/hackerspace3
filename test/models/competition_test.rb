require 'test_helper'

class CompetitionTest < ActiveSupport::TestCase
  setup do
    @competition = Competition.first
    @assignment = Assignment.first
    @sponsor = Sponsor.first
    @sponsorship_type = SponsorshipType.first
    @event = Event.first
    @team = Team.first
    @project =  Project.first
    @challenge = Challenge.first
    @checkpoint = Checkpoint.first
    @data_set = DataSet.first
    @criterion = Criterion.first
  end

  test 'competition associations' do
    assert @competition.assignments.include? @assignment
    assert @competition.sponsors.include? @sponsor
    assert @competition.sponsorship_types.include? @sponsorship_type
    assert @competition.events.include? @event
    assert @competition.teams.include? @team
    assert @competition.projects.include? @project
    assert @competition.challenges.include? @challenge
    assert @competition.checkpoints.include? @checkpoint
    assert @competition.data_sets.include? @data_set
    assert @competition.criteria.include? @criterion
  end

  test 'competition validations' do
    @competition.destroy
    # No year
    competition = Competition.create(year: nil)
    assert_not competition.persisted?
  end
end
