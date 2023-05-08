# == Schema Information
#
# Table name: scores
#
#  id           :bigint           not null, primary key
#  header_id    :integer
#  criterion_id :integer
#  entry        :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
require 'test_helper'

class ScoreTest < ActiveSupport::TestCase
  setup do
    @score = scores(:one)
    @header= headers(:one)
    @criterion = criteria(:one)
  end

  test 'score associations' do
    assert @score.header == @header
    assert @score.criterion == @criterion
  end

  test 'score validation' do
    assert_not @score.update criterion_id: 2
  end
end
