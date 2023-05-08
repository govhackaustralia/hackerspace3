# == Schema Information
#
# Table name: event_partnerships
#
#  id         :bigint           not null, primary key
#  event_id   :integer
#  sponsor_id :integer
#  approved   :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
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
