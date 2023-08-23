# frozen_string_literal: true

# == Schema Information
#
# Table name: competitions
#
#  id                      :bigint           not null, primary key
#  challenge_judging_end   :datetime
#  challenge_judging_start :datetime
#  current                 :boolean
#  end_time                :datetime
#  hunt_published          :boolean
#  peoples_choice_end      :datetime
#  peoples_choice_start    :datetime
#  start_time              :datetime
#  team_form_end           :datetime
#  team_form_start         :datetime
#  year                    :integer
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  hunt_badge_id           :integer
#
# Indexes
#
#  index_competitions_on_current  (current)
#  index_competitions_on_year     (year)
#
require 'test_helper'

class CompetitionTest < ActiveSupport::TestCase
  setup do
    @competition = competitions(:one)
    @assignment = assignments(:management_team)
    @sponsor = sponsors(:one)
    @sponsorship_type = sponsorship_types(:one)
    @event = events(:connection)
    @connection_event = @event
    @connection_registration = registrations(:attending)
    @competition_event = events(:competition)
    @competition_registration = registrations(:attending_two)
    @award_event = events(:award)
    @award_registration = registrations(:attending_three)
    @team = teams(:one)
    @team_data_set = team_data_sets(:one)
    @project = projects(:one)
    @challenge = challenges(:one)
    @entry = entries(:one)
    @checkpoint = checkpoints(:one)
    @data_set = data_sets(:one)
    @criterion = criteria(:one)
    @project_criterion = criteria(:one)
    @challenge_criterion = criteria(:two)
    @old_competition = @competition
    @new_competition = competitions(:two)
    @event_assignment = assignments(:participant)
  end

  test 'direct competition associations' do
    assert @competition.project_criteria.include? @project_criterion
    assert @competition.challenge_criteria.include? @challenge_criterion
    assert @competition.hunt_questions.include? hunt_questions(:one)
    assert @competition.badges.include? badges(:one)
    assert @competition.criteria.include? @criterion
    assert_includes @competition.resources, resources(:one)
    assert @competition.sponsorship_types.include? @sponsorship_type
    assert @competition.regions.include? regions(:international)
    assert @competition.sponsors.include? @sponsor
    assert @competition.checkpoints.include? @checkpoint
  end

  test 'competition associations' do
    assert @competition.assignments.include? @assignment
    assert @competition.users.include? users(:one)
    assert @competition.profiles.include? profiles(:one)
    assert @competition.teams.include? @team
    assert @competition.projects.include? @project
    assert @competition.team_data_sets.include? @team_data_set
    assert @competition.challenges.include? @challenge
    assert @competition.entries.include? @entry
    assert @competition.data_sets.include? @data_set
    assert @competition.competition_assignments.include? @assignment
  end

  test 'competition event associations' do
    assert @competition.events.include? @event
    assert @competition.connection_events.include? @connection_event
    assert @competition.connection_registrations.include? @connection_registration
    assert @competition.conference_events.include? events :conference
    assert @competition.conference_registrations.include? registrations :conference_registration
    assert @competition.competition_events.include? @competition_event
    assert @competition.competition_registrations.include? @competition_registration
    assert @competition.award_events.include? @award_event
    assert @competition.award_registrations.include? @award_registration
  end

  test 'dependent destroy' do
    @competition.destroy!

    assert_raises(ActiveRecord::RecordNotFound) { resources(:one).reload }
    assert_raises(ActiveRecord::RecordNotFound) { visits(:resource).reload }
  end

  test 'competition belongs to associations' do
    assert_equal badges(:hunt_badge), @competition.hunt_badge
  end

  test 'competition validations' do
    @competition.destroy
    # No year
    competition = Competition.create(year: nil)
    assert_not competition.persisted?
  end

  test 'competition callbacks' do
    @new_competition.update! current: true

    assert_not @old_competition.reload.current
  end

  test 'root region' do
    assert_equal regions(:international), @competition.international_region
  end

  test 'started?' do
    @competition.update! start_time: Time.now - 1.day

    assert @competition.started?('Sydney')
  end

  test 'not started?' do
    @competition.update! start_time: Time.now + 1.day

    assert_not @competition.started?('Sydney')
  end

  test 'not_finished?' do
    @competition.update! end_time: Time.now - 1.day

    assert_not @competition.not_finished?('Sydney')
  end

  test 'not not_finished?' do
    @competition.update! end_time: Time.now + 1.day

    assert @competition.not_finished?('Sydney')
  end

  test 'in_comp_window?' do
    @competition.update! start_time: Time.now - 1.day, end_time: Time.now + 1.day

    assert @competition.in_comp_window?('Sydney')
  end

  test 'not in_comp_window?' do
    @competition.update! end_time: Time.now - 1.hour

    assert_not @competition.in_comp_window?('Sydney')
  end

  test 'in_form_or_comp_window?' do
    @competition.update!(
      start_time: Time.now - 1.day,
      end_time: Time.now + 1.day,
      team_form_start: Time.now - 1.day,
      team_form_end: Time.now - 1.day,
    )

    assert @competition.in_form_or_comp_window?('Sydney')
  end

  test 'not in_form_or_comp_window?' do
    @competition.update!(
      end_time: Time.now - 1.hour,
      team_form_end: Time.now - 1.hour,
    )

    assert_not @competition.in_form_or_comp_window?('Sydney')
  end

  test 'in_challenge_judging_window?' do
    @competition.update!(
      challenge_judging_start: Time.now - 1.day,
      challenge_judging_end: Time.now + 1.day,
    )

    assert @competition.in_challenge_judging_window?('Sydney')
  end

  test 'not in_challenge_judging_window?' do
    @competition.update! challenge_judging_end: Time.now - 1.hour

    assert_not @competition.in_challenge_judging_window?('Sydney')
  end

  test 'in_peoples_judging_window?' do
    @competition.update!(
      peoples_choice_start: Time.now - 1.day,
      peoples_choice_end: Time.now + 1.day,
    )

    assert @competition.in_peoples_judging_window?('Sydney')
  end

  test 'not in_peoples_judging_window?' do
    @competition.update! peoples_choice_end: Time.now - 1.hour

    assert_not @competition.in_peoples_judging_window?('Sydney')
  end

  test 'in either_judging_window_open?' do
    @competition.update!(
      peoples_choice_start: Time.now - 1.day,
      peoples_choice_end: Time.now + 1.day,
      challenge_judging_start: Time.now - 1.day,
      challenge_judging_end: Time.now - 1.hour,
    )

    assert @competition.either_judging_window_open?('Sydney')
  end

  test 'not in either_judging_window_open?' do
    @competition.update! peoples_choice_end: Time.now - 1.hour

    assert_not @competition.either_judging_window_open?('Sydney')
  end

  test 'already_participating_in_a_competition_event?' do
    assert @competition.already_participating_in_a_competition_event? @event_assignment
  end

  test 'before sunday judging?' do
    time_now = Time.now.in_time_zone('Brisbane')
    # end time in the future
    @competition.update! end_time: time_now + 1.day

    assert_not @competition.in_sunday_judging?('Brisbane')
  end

  test 'during sunday judging?' do
    time_now = Time.now.in_time_zone('Brisbane')
    # end time in the past and after 4pm
    @competition.update! end_time: Time.new(time_now.year, time_now.month, time_now.day, 0, 0, 0)

    assert @competition.in_sunday_judging?('Brisbane')
  end

  test 'after sunday judging?' do
    time_now = Time.now.in_time_zone('Brisbane')
    # end time in the past and after midday
    @competition.update! end_time: time_now - 2.days

    assert_not @competition.in_sunday_judging?('Brisbane')
  end
end
