# frozen_string_literal: true

# == Schema Information
#
# Table name: regions
#
#  id             :bigint           not null, primary key
#  award_release  :datetime
#  category       :string
#  identifier     :string
#  is_show        :integer
#  name           :string
#  time_zone      :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  competition_id :integer
#  parent_id      :integer
#
# Indexes
#
#  index_regions_on_competition_id  (competition_id)
#  index_regions_on_identifier      (identifier)
#  index_regions_on_parent_id       (parent_id)
#
require 'test_helper'

class RegionTest < ActiveSupport::TestCase
  setup do
    @national = regions(:national)
    @competition = competitions(:one)
    @regional = regions(:regional)
    @assignment = assignments(:region_director)
    @event = events(:connection)
    @team = teams(:one)
    @published_project = projects(:one)
    @entry = entries(:one)
    @sponsorship = sponsorships(:two)
    @sponsorship_type = sponsorship_types(:one)
    @challenge = challenges(:one)
    @data_set = data_sets(:one)
    @support_assignment = assignments(:region_support)
    @support = users(:one)
    @next_competition = competitions(:two)
    @international = regions(:international)
    @region_limit = region_limits(:one)
    @regionalless_national = regions(:other_national)
    @national_team = teams(:two)
    @regional_challenge = challenges(:three)
  end

  test 'region associations' do
    assert @international.sub_regions.include? @national
    assert @national.sub_region_teams.include? @team
    assert @national.sub_region_challenges.include? @regional_challenge
    assert @regional.parent == @national
    assert @national.competition == @competition
    assert @national.assignments.include? @assignment
    assert @regional.events.include? @event
    assert @regional.teams.include? @team
    assert @regional.published_projects_by_name.include? @published_project
    assert @regional.entries.include? @entry
    assert @national.sponsorships.include? @sponsorship
    assert @national.sponsorship_types.include? @sponsorship_type
    assert @national.challenges.include? @challenge
    assert @national.approved_challenges.include? @challenge
    assert @national.data_sets.include? @data_set
    assert @national.support_assignments.include? @support_assignment
    assert @national.supports.include? @support
    assert @national.region_limits.include? @region_limit
  end

  test 'region scopes' do
    assert Region.regionals.include? @regional
    assert Region.regionals.exclude? @national
    assert Region.nationals.include? @national
    assert Region.nationals.exclude? @regional
    assert Region.internationals.include? @international
    assert Region.internationals.exclude? @regional
    assert Region.lows.include? @regional
    assert Region.lows.exclude? @international
    assert Region.highs.include? @national
    assert Region.highs.include? @international
    assert Region.highs.exclude? @regional
  end

  test 'region validations' do
    # No name given
    assert_not @competition.regions.create.persisted?
    # Duplicate name
    assert_not @competition.regions.create(name: @national.name).persisted?
    # Time zone not required
    assert @competition.regions.nationals.create(
      name: 'y',
      parent: @international,
    ).persisted?
    # Incorrect Region
    assert_not @competition.regions.create(
      name: 'x', time_zone: 'Timbuktu',
    ).persisted?
    # Correct Region
    assert @competition.regions.regionals.create(
      name: 'x',
      time_zone: 'Brisbane',
      parent: @national,
    ).persisted?
    # Same Name Same Competition
    assert_not @competition.regions.create(
      name: 'x', time_zone: 'Brisbane', parent: @national,
    ).persisted?
    # Same Name Different Competition
    assert @next_competition.regions.regionals.create(
      name: 'x',
      time_zone: 'Brisbane',
      parent: @next_competition.international_region,
    ).persisted?
  end

  test 'category checks' do
    assert @national.national?
    assert @regional.regional?
    assert @international.international?
    assert_not @national.regional?
    assert_not @regional.national?
    assert_not @regional.international?
  end

  test 'region director' do
    # Retrievs Director
    assert @assignment.user == @national.director
  end

  test 'limit' do
    checkpoint = checkpoints(:one)
    assert @national.limit(checkpoint) == @region_limit
    assert @regional.limit(checkpoint) == @region_limit
    assert @international.limit(checkpoint).nil?
  end

  test 'competing_teams' do
    assert @international.competing_teams.include? @team
    assert @regionalless_national.competing_teams.include? @national_team
    assert @regional.competing_teams.include? @team
    assert @national.competing_teams.include? @team
  end

  test 'only_one_international_per_competition' do
    assert_not @competition.regions.create(name: 'Second Root').persisted?
  end

  test 'only_international_can_be_parent_of_national' do
    assert_not @competition.regions.nationals.create(
      name: 'New National',
      parent: @regional,
    ).persisted?
    assert @competition.regions.nationals.create(
      name: 'New National',
      parent: @international,
    ).persisted?
  end

  test 'time' do
    assert @regional.time.is_a? String
    assert @international.time.is_a? String
  end

  test 'Region.region_time' do
    assert Region.region_time.is_a? String
  end

  test 'only_national_can_be_parent_of_regional' do
    assert_not @competition.regions.regionals.create(
      name: 'New Regional',
      parent: @international,
    ).persisted?
    assert @competition.regions.regionals.create(
      name: 'New Regional',
      parent: @national,
    ).persisted?
  end

  test 'eligible_challenges' do
    challenges(:one).update region: regions(:international)
    assert @international.eligible_challenges.present?
    assert @national.eligible_challenges.present?
    assert @regional.eligible_challenges.present?
  end

  test 'zone_code_when' do
    event = events(:other_competition)
    region = regions(:other_national)
    event.update! start_time: '10th December', end_time: '10th July'

    assert region.zone_code_when(event.start_time) == 'NZDT'
    assert region.zone_code_when(event.end_time) == 'NZST'
  end

  test 'try to add parent when already child' do
    assert_equal @international, @national.parent

    error = assert_raises ActiveRecord::RecordInvalid do
      @international.update! parent: @national
    end
    assert_match 'Validation failed: Parent already a descendant region',
      error.message
  end
end
