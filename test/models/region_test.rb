require 'test_helper'

class RegionTest < ActiveSupport::TestCase
  setup do
    @parent = Region.first
    @competition = Competition.first
    @child = Region.second
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
  end

  test 'region associations' do
    assert @child.parent == @parent
    assert @parent.competition == @competition
    assert @parent.sub_regions.include? @child
    assert @parent.assignments.include? @assignment
    assert @child.events.include? @event
    assert @child.teams.include? @team
    assert @child.published_projects_by_name.include? @published_project
    assert @child.entries.include? @entry
    assert @parent.sponsorships.include? @sponsorship
    assert @parent.sponsorship_types.include? @sponsorship_type
    assert @parent.challenges.include? @challenge
    assert @parent.data_sets.include? @data_set
    assert @parent.bulk_mails.include? @bulk_mail
    assert @parent.support_assignments.include? @support_assignment
    assert @parent.supports.include? @support
  end

  test 'region scopes' do
    assert Region.subs.include? @child
    assert Region.subs.exclude? @parent
    assert Region.roots.include? @parent
    assert Region.roots.exclude? @child
  end

  test 'region validations' do
    # No name given
    assert_not @competition.regions.create.persisted?
    # Duplicate name
    assert_not @competition.regions.create(name: @parent.name).persisted?
    # Time zone not required
    assert @competition.regions.create!(name: 'y', parent: @parent).persisted?
    # Incorrect Region
    assert_not @competition.regions.create(name: 'x', time_zone: 'Timbuktu').persisted?
    # Correct Region
    assert @competition.regions.create!(name: 'x', time_zone: 'Brisbane', parent: @parent).persisted?
  end

  test 'region director' do
    # Retrievs Director
    assert @assignment.user == @parent.director
  end
end
