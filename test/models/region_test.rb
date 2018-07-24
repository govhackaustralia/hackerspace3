require 'test_helper'

class RegionTest < ActiveSupport::TestCase
  setup do
    @parent_region = Region.first
    @child_region = Region.second
    @event = Event.first
    @assignment = Assignment.second
    @user = User.first
  end

  test 'region associations' do
    assert(@parent_region.sub_regions.include?(@child_region))
    assert(@child_region.parent == @parent_region)
    assert(@parent_region.assignments.include?(@assignment))
    assert(@child_region.events.include?(@event))
  end

  test 'region validations' do
    # No name given
    assert_not(Region.create.persisted?)
    # Duplicate name
    assert_not(Region.create(name: @parent_region.name).persisted?)
    # Time zone not required
    assert(Region.create(name: 'y').persisted?)
    # Incorrect Region
    assert_not(Region.create(name: 'x', time_zone: 'Timbuktu').persisted?)
    # Correct Region
    assert(Region.create(name: 'x', time_zone: 'Brisbane').persisted?)
  end

  test 'region director' do
    # Retrievs Director
    assert(@assignment.user == @parent_region.director)
    # Creates Director
    @assignment.destroy
    @parent_region.assign_director(@user)
    assert(@parent_region.director == @user)
  end
end
