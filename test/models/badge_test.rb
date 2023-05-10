# frozen_string_literal: true

# == Schema Information
#
# Table name: badges
#
#  id             :bigint           not null, primary key
#  capacity       :integer
#  identifier     :string
#  name           :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  competition_id :integer
#
# Indexes
#
#  index_badges_on_identifier  (identifier)
#
require 'test_helper'

class BadgeTest < ActiveSupport::TestCase
  setup do
    @badge = badges(:one)
    @competition = competitions(:one)
    @assignment = assignments(:badge_assignment)
  end

  test 'associations' do
    assert @badge.competition == @competition
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
