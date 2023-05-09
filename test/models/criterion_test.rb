# == Schema Information
#
# Table name: criteria
#
#  id             :bigint           not null, primary key
#  category       :string
#  description    :text
#  name           :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  competition_id :integer
#
# Indexes
#
#  index_criteria_on_competition_id  (competition_id)
#
require 'test_helper'

class CriterionTest < ActiveSupport::TestCase
  setup do
    @criterion = criteria(:one)
    @competition = competitions(:one)
    @score = scores(:one)
  end

  test 'criterion associations' do
    assert @criterion.competition == @competition
    assert @criterion.scores.include? @score
  end

  test 'criterion validations' do
    assert_not @criterion.update(description: nil)
    assert @criterion.update(description: 'Test')
    assert_not @criterion.update(name: nil)
    assert @criterion.update(name: 'Test')
    assert_not @criterion.update(category: 'Test')
    assert @criterion.update!(category: JUDGEMENT_CATEGORIES.sample)
  end
end
