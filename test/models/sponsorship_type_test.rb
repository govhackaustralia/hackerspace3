require 'test_helper'

class SponsorshipTypeTest < ActiveSupport::TestCase
  setup do
    @sponsorship_type = SponsorshipType.first
    @competition = Competition.first
    @sponsorship = Sponsorship.first
  end

  test 'sponsorship type associations' do
    assert @sponsorship_type.competition == @competition
    assert @sponsorship_type.sponsorships.include? @sponsorship
  end

  test 'sponsorship type validations' do
    assert_not SponsorshipType.new(name: 'example', order: nil).save
    assert_not SponsorshipType.new(name: nil, order: 1).save
  end
end
