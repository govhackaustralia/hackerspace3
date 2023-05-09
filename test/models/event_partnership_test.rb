# == Schema Information
#
# Table name: event_partnerships
#
#  id         :bigint           not null, primary key
#  approved   :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  event_id   :integer
#  sponsor_id :integer
#
# Indexes
#
#  index_event_partnerships_on_approved    (approved)
#  index_event_partnerships_on_event_id    (event_id)
#  index_event_partnerships_on_sponsor_id  (sponsor_id)
#
require 'test_helper'

class EventPartnershipTest < ActiveSupport::TestCase
  setup do
    @event_partnership = event_partnerships(:one)
    @event = events(:connection)
    @sponsor = sponsors(:one)
  end

  test 'event partnership associations' do
    assert @event_partnership.event == @event
    assert @event_partnership.sponsor == @sponsor
  end
end
