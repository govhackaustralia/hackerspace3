require 'test_helper'

class ChallengeTest < ActiveSupport::TestCase
  setup do
    @challenge = Challenge.first
    @competition = Competition.first
    @region = Region.first
    @assignment = Assignment.find(7)
    @user = User.second
    @entry = Entry.first
    @team = Team.first
    @challenge_sponsorship = ChallengeSponsorship.first
    @sponsor = Sponsor.first
    @challenge_data_set = ChallengeDataSet.first
    @data_set = DataSet.first
  end

  test 'challenge associations' do
    assert @challenge.competition == @competition
    assert @challenge.region == @region
    assert @challenge.assignments.include? @assignment
    assert @challenge.users.include? @user
    assert @challenge.entries.include? @entry
    assert @challenge.teams.include? @team
    assert @challenge.challenge_sponsorships.include? @challenge_sponsorship
    assert @challenge.sponsors.include? @sponsor
    assert @challenge.challenge_data_sets.include? @challenge_data_set
    assert @challenge.data_sets.include? @data_set
    @challenge.destroy
    assert_raises(ActiveRecord::RecordNotFound) { @assignment.reload }
    assert_raises(ActiveRecord::RecordNotFound) { @entry.reload }
    assert_raises(ActiveRecord::RecordNotFound) { @challenge_sponsorship.reload }
    assert_raises(ActiveRecord::RecordNotFound) { @challenge_data_set.reload }
  end

  test 'challenge scopes' do
    assert Challenge.approved.include? @challenge
    @challenge.update approved: false
    assert Challenge.approved.exclude? @challenge
  end

  test 'challenge validations' do
    assert_not @challenge.update(name: nil)
    challenge2 = Challenge.second
    assert_not @challenge.update(name: challenge2.name)
  end
end
