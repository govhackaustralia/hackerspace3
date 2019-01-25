require 'test_helper'

class SponsorTest < ActiveSupport::TestCase
  setup do
    @sponsor = Sponsor.first
    @competition = Competition.first
    @assignment = Assignment.fifth
    @sponsorship = Sponsorship.first
    @event_partnership = EventPartnership.first
    @challenge_sponsorship = ChallengeSponsorship.first
  end

  test 'sponsor associations' do
    assert @sponsor.competition == @competition
    assert @sponsor.assignments.include? @assignment
    assert @sponsor.sponsorships.include? @sponsorship
    assert @sponsor.event_partnerships.include? @event_partnership
    assert @sponsor.challenge_sponsorships.include? @challenge_sponsorship
    @sponsor.destroy
    assert_raises(ActiveRecord::RecordNotFound) { @assignment.reload }
  end

  test 'sponsor validations' do
    assert_not @sponsor.update name: nil
    assert_not @sponsor.update name: Sponsor.second.name
  end

  test 'sponsor scopes' do
    assert Sponsor.search(@sponsor.name[0]).include? @sponsor
    assert Sponsor.search(@sponsor.description[0]).include? @sponsor
  end
end
