# == Schema Information
#
# Table name: sponsors
#
#  id             :bigint           not null, primary key
#  description    :text
#  name           :string
#  url            :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  competition_id :integer
#
# Indexes
#
#  index_sponsors_on_competition_id  (competition_id)
#
require 'test_helper'

class SponsorTest < ActiveSupport::TestCase
  setup do
    @sponsor = sponsors(:one)
    @competition = competitions(:one)
    @assignment = assignments(:sponsor_contact)
    @sponsorship = sponsorships(:one)
    @event_partnership = event_partnerships(:one)
    @challenge_sponsorship = challenge_sponsorships(:one)
  end

  test 'sponsor associations' do
    assert @sponsor.competition == @competition
    assert @sponsor.assignments.include? @assignment
    assert @sponsor.sponsorships.include? @sponsorship
    assert @sponsor.event_partnerships.include? @event_partnership
    assert @sponsor.challenge_sponsorships.include? @challenge_sponsorship
    assert @sponsor.visits.include? visits(:sponsor)

    @sponsor.destroy

    assert_raises(ActiveRecord::RecordNotFound) { @assignment.reload }
    assert_raises(ActiveRecord::RecordNotFound) { visits(:sponsor).reload }
  end

  test 'sponsor validations' do
    assert_not @sponsor.update name: nil
    assert_not @sponsor.update name: sponsors(:two).name
  end

  test 'sponsor scopes' do
    assert Sponsor.search(@sponsor.name[0]).include? @sponsor
    assert Sponsor.search(@sponsor.description[0]).include? @sponsor
  end
end
