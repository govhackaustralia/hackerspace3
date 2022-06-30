require 'test_helper'

class EntryTest < ActiveSupport::TestCase
  setup do
    @entry = entries(:one)
    @checkpoint = Checkpoint.first
    @challenge = challenges(:one)
    @team = Team.first
    @event = @team.event
    @team_region = @team.region
    @project = @team.current_project
    @competition = competitions(:one)
    @region = regions(:national)
    @header= Header.first
    @regional_entry = entries(:three)
    @national_entry = @entry
    @next_competition = competitions(:two)
  end

  test 'entry associations' do
    assert @entry.checkpoint == @checkpoint
    assert @entry.challenge == @challenge
    assert @entry.team == @team
    assert @entry.event == @event
    assert @entry.team_region == @team_region
    assert @entry.competition == @competition
    assert @entry.project == @project
    assert @entry.region == @region
    assert @entry.headers.include? @header
    @entry.destroy
    assert_raises(ActiveRecord::RecordNotFound) { @header.reload }
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
    assert Entry.published.include? @regional_entry
  end

  test 'entry validations' do
    # Only certain award types.
    assert @entry.update! award: AWARD_NAMES.sample
    assert_not @entry.update award: 'Test'
    # No duplicate entries by Team into Challenge.
    assert_not entries(:two).update challenge: @challenge
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
      user: users(:one),
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
        challenge: challenges(:one),
        team: Team.second,
        checkpoint: Checkpoint.first
      )
    end
    assert exception.message.include?(
      'Challenge Team not eligible to enter this challenge'
    )
    assert Entry.create!(
      challenge: challenges(:one),
      team: Team.first,
      checkpoint: Checkpoint.first
    ).persisted?
  end
end
