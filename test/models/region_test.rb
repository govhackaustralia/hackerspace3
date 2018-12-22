require 'test_helper'

class RegionTest < ActiveSupport::TestCase
  setup do
    @parent_region = Region.first
    @child_region = Region.second
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
  end

  test 'region associations' do
    assert @child_region.parent == @parent_region
    assert @parent_region.sub_regions.include? @child_region
    assert @parent_region.assignments.include? @assignment
    assert @child_region.events.include? @event
    assert @child_region.teams.include? @team
    assert @child_region.published_projects_by_name.include? @published_project
    assert @child_region.entries.include? @entry
    assert @parent_region.sponsorships.include? @sponsorship
    assert @parent_region.sponsorship_types.include? @sponsorship_type
    assert @parent_region.challenges.include? @challenge
    assert @parent_region.data_sets.include? @data_set
    assert @parent_region.bulk_mails.include? @bulk_mail
  end

  test 'region scopes' do
    assert Region.sub_regions.include? @child_region
    assert Region.sub_regions.exclude? @parent_region
  end

  test 'region validations' do
    # No name given
    assert_not Region.create.persisted?
    # Duplicate name
    assert_not Region.create(name: @parent_region.name).persisted?
    # Time zone not required
    assert Region.create(name: 'y').persisted?
    # Incorrect Region
    assert_not Region.create(name: 'x', time_zone: 'Timbuktu').persisted?
    # Correct Region
    assert Region.create(name: 'x', time_zone: 'Brisbane').persisted?
  end

  test 'region director' do
    # Retrievs Director
    assert @assignment.user == @parent_region.director
  end
end
