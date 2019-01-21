require 'test_helper'

class CompetitionsHelperTest < ActionView::TestCase
  setup do
    @competition = Competition.first
  end

  test 'competition_started?' do
    @competition.update start_time: Time.now - 1.day
    assert competition_started?
    @competition.update start_time: Time.now + 1.day
    assert_not competition_started?
  end

  test 'competition_not_finished?' do
    @competition.update end_time: Time.now - 1.day
    assert_not competition_not_finished?
    @competition.update end_time: Time.now + 1.day
    assert competition_not_finished?
  end

  test 'in_competition_window?' do
    @competition.update start_time: Time.now - 1.day, end_time: Time.now + 1.day
    assert in_competition_window?
    @competition.update end_time: Time.now - 1.hour
    assert_not in_competition_window?
  end

  test 'in_challenge_judging_window?' do
    @competition.update challenge_judging_start: Time.now - 1.day,
                        challenge_judging_end: Time.now + 1.day
    assert in_challenge_judging_window?
    @competition.update challenge_judging_end: Time.now - 1.hour
    assert_not in_challenge_judging_window?
  end

  test 'in_peoples_judging_window?' do
    @competition.update peoples_choice_start: Time.now - 1.day,
                        peoples_choice_end: Time.now + 1.day
    assert in_peoples_judging_window?
    @competition.update peoples_choice_end: Time.now - 1.hour
    assert_not in_peoples_judging_window?
  end

  test 'either_judging_window_open?' do
    @competition.update peoples_choice_start: Time.now - 1.day,
                        peoples_choice_end: Time.now + 1.day,
                        challenge_judging_start: Time.now - 1.day,
                        challenge_judging_end: Time.now - 1.hour
    assert either_judging_window_open?
    @competition.update peoples_choice_end: Time.now - 1.hour
    assert_not either_judging_window_open?
  end
end
