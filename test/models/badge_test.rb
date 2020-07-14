require 'test_helper'

class BadgeTest < ActiveSupport::TestCase
  setup do
    @badge = badges(:one)
    @competition = competitions(:one)
    @assignment = assignments(:badge_assignment)
  end

  test 'associations' do
    assert @badge.competition ==  @competition
    assert @badge.assignments.include? @assignment
  end

  test 'validations' do
    assert_not Badge.new(competition: @competition, name: nil).save
    assert_not Badge.new(competition: @competition, name: @badge.name).save
  end

  test 'update_identifier callback' do
    badge = Badge.create(competition: competitions(:two), name: @badge.name)
    assert badge.identifier == 'mystring'
  end
end
