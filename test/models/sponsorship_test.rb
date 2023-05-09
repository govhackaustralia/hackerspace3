# == Schema Information
#
# Table name: sponsorships
#
#  id                  :bigint           not null, primary key
#  approved            :boolean          default(FALSE)
#  sponsorable_type    :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  sponsor_id          :integer
#  sponsorable_id      :integer
#  sponsorship_type_id :integer
#
# Indexes
#
#  index_sponsorships_on_approved                             (approved)
#  index_sponsorships_on_sponsor_id                           (sponsor_id)
#  index_sponsorships_on_sponsorable_type_and_sponsorable_id  (sponsorable_type,sponsorable_id)
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
