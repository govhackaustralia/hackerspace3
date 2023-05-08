# == Schema Information
#
# Table name: sponsorship_types
#
#  id             :bigint           not null, primary key
#  competition_id :integer
#  name           :string
#  position       :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
require 'test_helper'

class SponsorshipTypeTest < ActiveSupport::TestCase
  setup do
    @sponsorship_type = sponsorship_types(:one)
    @competition = competitions(:one)
    @sponsorship = sponsorships(:one)
  end

  test 'sponsorship type associations' do
    assert @sponsorship_type.competition == @competition
    assert @sponsorship_type.sponsorships.include? @sponsorship
    assert @sponsorship_type.sponsors.include? sponsors(:one)
  end

  test 'sponsorship type validations' do
    assert_not @competition.sponsorship_types.new(name: 'example', position: nil).save
    assert_not @competition.sponsorship_types.new(name: nil, position: 1).save
  end

  test 'position validation' do
    @competition.sponsorship_types.new(name: 'Paladium', position: 1).save!

    assert_equal 2, @sponsorship_type.reload.position
    assert_equal 4, sponsorship_types(:two).reload.position
  end
end
