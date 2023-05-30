# frozen_string_literal: true

require 'test_helper'

class ProfilesHelperTest < ActionView::TestCase
  test 'profile_slack_chat_url' do
    assert_equal(
      "slack://user?team=#{ENV.fetch('SLACK_TEAM_ID', nil)}&id=#{profiles(:one).slack_user_id}",
      profile_slack_chat_url(profiles(:one)),
    )
  end
end
