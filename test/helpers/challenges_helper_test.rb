# frozen_string_literal: true

require 'test_helper'

class ChallengesHelperTest < ActionView::TestCase
  test 'user_challenges_path for index' do
    cookies[:challenge_index_view] = 'index'
    assert user_challenges_path == challenges_path
  end

  test 'user_challenges_path for table_challenges_path' do
    cookies[:challenge_index_view] = 'table'
    assert user_challenges_path == table_challenges_path
  end
end
