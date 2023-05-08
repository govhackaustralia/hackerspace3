# == Schema Information
#
# Table name: visits
#
#  id             :bigint           not null, primary key
#  visitable_type :string           not null
#  visitable_id   :bigint           not null
#  user_id        :bigint
#  competition_id :bigint           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
require 'test_helper'

class VisitTest < ActiveSupport::TestCase
  test 'visit associations' do
    assert_equal users(:one), visits(:resource).user
    assert_equal competitions(:one), visits(:resource).competition
    assert_equal resources(:one), visits(:resource).visitable
  end
end
