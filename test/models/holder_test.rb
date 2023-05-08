# == Schema Information
#
# Table name: holders
#
#  id                    :bigint           not null, primary key
#  user_id               :bigint           not null
#  competition_id        :bigint           not null
#  aws_credits_requested :boolean
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  team_status           :integer
#  profile_id            :bigint
#
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
