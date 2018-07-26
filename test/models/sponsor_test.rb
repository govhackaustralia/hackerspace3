require 'test_helper'

class SponsorTest < ActiveSupport::TestCase
  setup do
    @sponsor = Sponsor.first
    @competition = Competition.first
    @assignment = Assignment.find(5)
    @sponsorship = Sponsorship.first
  end

  test 'sponsor associations' do
    assert(@sponsor.competition == @competition)
    assert(@sponsor.assignments.include?(@assignment))
    assert(@sponsor.sponsorships.include?(@sponsorship))
  end
end
