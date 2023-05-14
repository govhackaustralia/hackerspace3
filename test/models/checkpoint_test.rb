# frozen_string_literal: true

# == Schema Information
#
# Table name: checkpoints
#
#  id                      :bigint           not null, primary key
#  end_time                :datetime
#  max_national_challenges :integer
#  max_regional_challenges :integer
#  name                    :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  competition_id          :integer
#
# Indexes
#
#  index_checkpoints_on_competition_id  (competition_id)
#
require 'test_helper'

class CheckpointTest < ActiveSupport::TestCase
  setup do
    @checkpoint = checkpoints(:one)
    @competition = competitions(:one)
    @entry = entries(:one)
    @team = teams(:one)
    @international_region = regions(:national)
    @sub_region = regions(:regional)
  end

  test 'checkpoint associations' do
    assert @checkpoint.competition == @competition
    assert @checkpoint.entries.include? @entry
    @checkpoint.destroy
    assert_raises(ActiveRecord::RecordNotFound) { @entry.reload }
  end

  test 'checkpoint validations' do
    assert_not @checkpoint.update name: nil
    assert_not @checkpoint.update end_time: nil
    assert_not @checkpoint.update max_national_challenges: nil
    assert_not @checkpoint.update max_regional_challenges: nil
  end

  test 'limit reached' do
    assert @checkpoint.limit_reached? @team, @international_region
    assert_not @checkpoint.limit_reached? @team, @sub_region
  end
end
