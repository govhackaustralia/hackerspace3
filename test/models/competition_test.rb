require 'test_helper'

class CompetitionTest < ActiveSupport::TestCase
  setup do
    @competition = Competition.first
    @region = Region.third
    @assignment = Assignment.first
    @sponsor = Sponsor.first
    @sponsorship_type = SponsorshipType.first
    @event = Event.first
    @connection_event = @event
    @connection_registration = Registration.first
    @competition_event = Event.second
    @competition_registration = Registration.third
    @award_event = Event.third
    @award_registration = Registration.find 6
    @team = Team.first
    @project = Project.first
    @challenge = Challenge.first
    @checkpoint = Checkpoint.first
    @data_set = DataSet.first
    @criterion = Criterion.first
    @project_criterion = Criterion.first
    @challenge_criterion = Criterion.second
    @old_competition = @competition
    @new_competition = Competition.second
    @event_assignment = Assignment.fourth
  end

  test 'competition associations' do
    assert @competition.assignments.include? @assignment
    assert @competition.regions.include? @region
    assert @competition.sponsors.include? @sponsor
    assert @competition.sponsorship_types.include? @sponsorship_type
    assert @competition.events.include? @event
    assert @competition.connection_events.include? @connection_event
    assert @competition.connection_registrations.include? @connection_registration
    assert @competition.competition_events.include? @competition_event
    assert @competition.competition_registrations.include? @competition_registration
    assert @competition.award_events.include? @award_event
    assert @competition.award_registrations.include? @award_registration
    assert @competition.teams.include? @team
    assert @competition.projects.include? @project
    assert @competition.challenges.include? @challenge
    assert @competition.checkpoints.include? @checkpoint
    assert @competition.data_sets.include? @data_set
    assert @competition.criteria.include? @criterion
    assert @competition.project_criteria.include? @project_criterion
    assert @competition.challenge_criteria.include? @challenge_criterion
    assert @competition.competition_assignments.include? @assignment
  end

  test 'competition validations' do
    @competition.destroy
    # No year
    competition = Competition.create(year: nil)
    assert_not competition.persisted?
  end

  test 'competition callbacks' do
    @new_competition.update current: true
    assert_not @old_competition.reload.current
  end

  test 'root region' do
    assert @competition.international_region == @region
  end

  test 'started?' do
    @competition.update start_time: Time.now - 1.day
    assert @competition.started?
    @competition.update start_time: Time.now + 1.day
    assert_not @competition.started?
  end

  test 'not_finished?' do
    @competition.update end_time: Time.now - 1.day
    assert_not @competition.not_finished?
    @competition.update end_time: Time.now + 1.day
    assert @competition.not_finished?
  end

  test 'in_comp_window?' do
    @competition.update start_time: Time.now - 1.day, end_time: Time.now + 1.day
    assert @competition.in_comp_window?
    @competition.update end_time: Time.now - 1.hour
    assert_not @competition.in_comp_window?
  end

  test 'in_form_or_comp_started?' do
    @competition.update(
      start_time: Time.now - 1.day,
      end_time: Time.now + 1.day,
      team_form_start: Time.now - 1.day,
      team_form_end: Time.now - 1.day
    )
    assert @competition.in_form_or_comp_started?
    @competition.update(
      start_time: Time.now + 1.day,
      team_form_start: Time.now + 1.day,
      team_form_end: Time.now + 1.day
    )
    assert_not @competition.in_form_or_comp_window?
  end

  test 'in_form_or_comp_window?' do
    @competition.update(
      start_time: Time.now - 1.day,
      end_time: Time.now + 1.day,
      team_form_start: Time.now - 1.day,
      team_form_end: Time.now - 1.day
    )
    assert @competition.in_form_or_comp_window?
    @competition.update(
      end_time: Time.now - 1.hour,
      team_form_end: Time.now - 1.hour
    )
    assert_not @competition.in_form_or_comp_window?
  end

  test 'in_challenge_judging_window?' do
    @competition.update challenge_judging_start: Time.now - 1.day,
                        challenge_judging_end: Time.now + 1.day
    assert @competition.in_challenge_judging_window?
    @competition.update challenge_judging_end: Time.now - 1.hour
    assert_not @competition.in_challenge_judging_window?
  end

  test 'in_peoples_judging_window?' do
    @competition.update peoples_choice_start: Time.now - 1.day,
                        peoples_choice_end: Time.now + 1.day
    assert @competition.in_peoples_judging_window?
    @competition.update peoples_choice_end: Time.now - 1.hour
    assert_not @competition.in_peoples_judging_window?
  end

  test 'either_judging_window_open?' do
    @competition.update peoples_choice_start: Time.now - 1.day,
                        peoples_choice_end: Time.now + 1.day,
                        challenge_judging_start: Time.now - 1.day,
                        challenge_judging_end: Time.now - 1.hour
    assert @competition.either_judging_window_open?
    @competition.update peoples_choice_end: Time.now - 1.hour
    assert_not @competition.either_judging_window_open?
  end

  test 'already_participating_in_a_competition_event?' do
    assert @competition.already_participating_in_a_competition_event? @event_assignment
  end
end
