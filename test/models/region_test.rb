require 'test_helper'

class RegionTest < ActiveSupport::TestCase
  setup do
    @national = Region.first
    @competition = Competition.first
    @regional = Region.second
    @assignment = Assignment.second
    @event = Event.first
    @team = Team.first
    @published_project = Project.first
    @entry = Entry.first
    @sponsorship = Sponsorship.second
    @sponsorship_type = SponsorshipType.first
    @challenge = Challenge.first
    @data_set = DataSet.first
    @bulk_mail = BulkMail.first
    @support_assignment = Assignment.find 14
    @support = User.first
    @next_competition = Competition.second
    @international = Region.third
  end

  test 'region associations' do
    assert @international.sub_regions.include? @national
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
    assert @national.data_sets.include? @data_set
    assert @national.bulk_mails.include? @bulk_mail
    assert @national.support_assignments.include? @support_assignment
    assert @national.supports.include? @support
  end

  test 'region scopes' do
    assert Region.lows.include? @regional
    assert Region.lows.exclude? @international
    assert Region.regionals.include? @regional
    assert Region.regionals.exclude? @national
    assert Region.nationals.include? @national
    assert Region.nationals.exclude? @regional
    assert Region.internationals.include? @international
    assert Region.internationals.exclude? @regional
  end

  test 'region validations' do
    # No name given
    assert_not @competition.regions.create.persisted?
    # Duplicate name
    assert_not @competition.regions.create(name: @national.name).persisted?
    # Time zone not required
    assert @competition.regions.nationals.create(
      name: 'y',
      parent: @international
    ).persisted?
    # Incorrect Region
    assert_not @competition.regions.create(
      name: 'x', time_zone: 'Timbuktu'
    ).persisted?
    # Correct Region
    assert @competition.regions.regionals.create(
      name: 'x',
      time_zone: 'Brisbane',
      parent: @national
    ).persisted?
    # Same Name Same Competition
    assert_not @competition.regions.create(
      name: 'x', time_zone: 'Brisbane', parent: @national
    ).persisted?
    # Same Name Different Competition
    assert @next_competition.regions.regionals.create(
      name: 'x',
      time_zone: 'Brisbane',
      parent: @next_competition.international_region
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

  test 'only_one_international_per_competition' do
    assert_not @competition.regions.create(name: 'Second Root').persisted?
  end

  test 'only_international_can_be_parent_of_national' do
    assert_not @competition.regions.nationals.create(
      name: 'New National',
      parent: @regional
    ).persisted?
    assert @competition.regions.nationals.create(
      name: 'New National',
      parent: @international
    ).persisted?
  end

  test 'only_national_can_be_parent_of_regional' do
    assert_not @competition.regions.regionals.create(
      name: 'New Regional',
      parent: @international
    ).persisted?
    assert @competition.regions.regionals.create(
      name: 'New Regional',
      parent: @national
    ).persisted?
  end
end
