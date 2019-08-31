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
    # No duplicate entries by Team into Challenge.
    assert_not Entry.second.update challenge: @challenge
  end

  test 'update eligible' do
    Entry.destroy_all
    entry = @team.entries.create(
      checkpoint: @checkpoint,
      challenge: @challenge,
      justification: 'Test'
    )
    assert_not entry.eligible
    @team.projects.create(
      user: User.first,
      team_name: 'test',
      project_name: 'test',
      data_story: 'test',
      video_url: 'test',
      source_code_url: 'test'
    )
    assert entry.eligible
  end

  test 'teams_cannot_enter_challenges_they_are_not_eligible_for' do
    Entry.destroy_all
    exception = assert_raises(ActiveRecord::RecordInvalid) do
      Entry.create!(
        challenge: Challenge.first,
        team: Team.second,
        checkpoint: Checkpoint.first
      )
    end
    assert exception.message.include?(
      'Challenge Team not eligible to enter this challenge'
    )
    assert Entry.create!(
      challenge: Challenge.first,
      team: Team.first,
      checkpoint: Checkpoint.first
    ).persisted?
  end
end
