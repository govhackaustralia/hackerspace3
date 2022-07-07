require 'test_helper'

class HolderTest < ActiveSupport::TestCase
  setup do
    @holder = holders(:one)
    @user = users(:one)
    @competition = competitions(:one)
  end

  test 'associations' do
    assert @holder.user == @user
    assert profiles(:one), holders(:one).profile
    assert @holder.competition == @competition
  end

  test 'enums' do
    assert Holder.team_statuses.is_a? Hash
  end
end
