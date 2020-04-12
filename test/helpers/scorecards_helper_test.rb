require 'test_helper'

class ScorecardsHelperTest < ActionView::TestCase
  setup do
    @header= Header.first
    @judge = User.first
    @peoples_assignment = Assignment.first
    @competition = Competition.first
  end

  test 'challenge_title_required?' do
    assert_not challenge_title_required? Score.first
  end

  test 'show_challenge_score_stuff?' do
    assert_not show_challenge_score_stuff?
  end

  test 'show_peoples_choice_stuff?' do
    assert_not show_peoples_choice_stuff?
  end
end
