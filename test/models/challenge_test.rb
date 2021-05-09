require 'test_helper'

class ChallengeTest < ActiveSupport::TestCase
  setup do
    @challenge = Challenge.first
    @competition = Competition.first
    @region = Region.first
    @assignment = Assignment.find(7)
    @user = User.second
    @entry = Entry.first
    @checkpoint = Checkpoint.first
    @team = Team.first
    @challenge_sponsorship = ChallengeSponsorship.first
    @sponsor = Sponsor.first
    @challenge_data_set = ChallengeDataSet.first
    @challenge_dataset = challenge_datasets(:one)
    @dataset = datasets(:one)
    @data_set = DataSet.first
    @regional_challenge = Challenge.third
  end

  test 'challenge associations' do
    assert @challenge.competition == @competition
    assert @challenge.region == @region
    assert @challenge.assignments.include? @assignment
    assert @challenge.judge_users.include? @user
    assert @challenge.entries.include? @entry
    assert @challenge.published_entries.include? @entry
    assert @challenge.entries_at(@checkpoint).include? @entry
    assert @challenge.teams.include? @team
    assert @challenge.challenge_sponsorships.include? @challenge_sponsorship
    assert @challenge.sponsors.include? @sponsor
    assert @challenge.sponsors_with_logos.include? @sponsor
    assert @challenge.challenge_data_sets.include? @challenge_data_set
    assert @challenge.data_sets.include? @data_set
    assert @challenge.challenge_datasets.include? @challenge_dataset
    assert @challenge.datasets.include? @dataset
    @challenge.destroy
    assert_raises(ActiveRecord::RecordNotFound) { @assignment.reload }
    assert_raises(ActiveRecord::RecordNotFound) { @entry.reload }
    assert_raises(ActiveRecord::RecordNotFound) { @challenge_sponsorship.reload }
    assert_raises(ActiveRecord::RecordNotFound) { @challenge_data_set.reload }
  end

  test 'challenge scopes' do
    assert Challenge.approved.include? @challenge
    assert Challenge.not_unapproved.include? @challenge
    @challenge.update! approved: false
    assert Challenge.approved.exclude? @challenge
    assert Challenge.not_unapproved.exclude? @challenge
    @challenge.update! approved: nil
    assert Challenge.approved.exclude? @challenge
    assert Challenge.not_unapproved.include? @challenge
    assert Challenge.nation_wides.include? @regional_challenge
    assert Challenge.nation_wides.exclude? @challenge
  end

  test 'challenge validations' do
    assert_not @challenge.update(name: nil)
    challenge2 = Challenge.second
    assert_not @challenge.update(name: challenge2.name)
  end

  test 'only_regional_challenges_can_be_marked_nation_wide' do
    assert_raises(ActiveRecord::RecordInvalid) do
      @challenge.update! nation_wide: true
    end
    @regional_challenge.update nation_wide: true
    assert @regional_challenge.reload.nation_wide
  end
end
