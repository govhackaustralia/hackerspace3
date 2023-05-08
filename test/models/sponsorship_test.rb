# == Schema Information
#
# Table name: sponsorships
#
#  id                  :bigint           not null, primary key
#  sponsor_id          :integer
#  sponsorship_type_id :integer
#  sponsorable_type    :string
#  sponsorable_id      :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  approved            :boolean          default(FALSE)
#
require 'test_helper'

class SponsorshipTest < ActiveSupport::TestCase
  setup do
    @event_sponsorship = sponsorships(:one)
    @region_sponsorship = sponsorships(:two)
    @sponsor = sponsors(:one)
    @event = events(:connection)
    @region = regions(:national)
    @sponsorship_type = sponsorship_types(:one)
  end

  test 'sponsorship associations' do
    assert @event_sponsorship.sponsor == @sponsor
    assert @region_sponsorship.sponsorable == @region
    assert @event_sponsorship.sponsorable == @event
    assert @region_sponsorship.sponsorship_type == @sponsorship_type
  end
end
