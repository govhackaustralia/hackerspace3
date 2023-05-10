# frozen_string_literal: true

# == Schema Information
#
# Table name: visits
#
#  id             :bigint           not null, primary key
#  visitable_type :string           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  competition_id :bigint           not null
#  user_id        :bigint
#  visitable_id   :bigint           not null
#
# Indexes
#
#  index_visits_on_competition_id  (competition_id)
#  index_visits_on_user_id         (user_id)
#  index_visits_on_visitable       (visitable_type,visitable_id)
#
# Foreign Keys
#
#  fk_rails_...  (competition_id => competitions.id)
#  fk_rails_...  (user_id => users.id)
#
require 'test_helper'

class VisitTest < ActiveSupport::TestCase
  test 'visit associations' do
    assert_equal users(:one), visits(:resource).user
    assert_equal competitions(:one), visits(:resource).competition
    assert_equal resources(:one), visits(:resource).visitable
  end
end
