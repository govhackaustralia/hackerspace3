require 'test_helper'

class EntryTest < ActiveSupport::TestCase
  setup do
    @entry = Entry.first
    @checkpoint = Checkpoint.first
    @challenge = Challenge.first
    @team = Team.first
    @competition = Competition.first
    @region = Region.first
    @scorecard = Scorecard.first
    @regional_entry = Entry.third
    @national_entry = @entry
    @next_competition = Competition.second
  end

  test 'entry associations' do
    assert @entry.checkpoint == @checkpoint
    assert @entry.challenge == @challenge
    assert @entry.team == @team
    assert @entry.competition == @competition
    assert @entry.region == @region
    assert @entry.scorecards.include? @scorecard
    @entry.destroy
    assert_raises(ActiveRecord::RecordNotFound) { @scorecard.reload }
  end

  test 'entry scopes' do
    assert Entry.regional.include? @regional_entry
    assert Entry.regional.exclude? @national_entry
    assert Entry.national.include? @national_entry
    assert Entry.national.exclude? @regional_entry
    assert Entry.winners.include? @regional_entry
    assert Entry.winners.exclude? @national_entry
    assert Entry.competition(@competition).include? @entry
    assert Entry.competition(@next_competition).exclude? @entry
  end

  test 'entry validations' do
    # Only certain award types.
    assert @entry.update! award: AWARD_NAMES.sample
    assert_not @entry.update award: 'Test'
    # Justification cannot be nil
    assert_not @entry.update justification: nil
    # No duplicate entries by Team into Challenge.
    assert_not Entry.second.update challenge: @challenge
  end
end
