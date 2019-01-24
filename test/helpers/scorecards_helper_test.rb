require 'test_helper'

class ScorecardsHelperTest < ActionView::TestCase
  setup do
    @scorecard = Scorecard.first
    @judge = User.first
    @peoples_assignment = Assignment.first
    @competition = Competition.first
  end

  test 'challenge_title_required?' do
    assert_not challenge_title_required? Judgment.first
  end

  test 'show_challenge_judgment_stuff?' do
    assert_not show_challenge_judgment_stuff?
  end

  test 'show_peoples_choice_stuff?' do
    assert_not show_peoples_choice_stuff?
  end
end
