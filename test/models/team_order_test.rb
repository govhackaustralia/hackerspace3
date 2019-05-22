require 'test_helper'

class TeamOrderTest < ActiveSupport::TestCase
  setup do
    @team_order = TeamOrder.first
    @bulk_mail = BulkMail.first
    @team = Team.first
    @correspondence = Correspondence.first
  end

  test 'team order associations' do
    assert @team_order.bulk_mail == @bulk_mail
    assert @team_order.team == @team
    assert @team_order.correspondences.include? @correspondence
  end

  test 'team validations' do
    assert @team_order.update request_type: TEAM_ORDER_REQUEST_TYPES.sample
    assert_not @team_order.update request_type: 'TEST'
    assert_not @team_order.update team_id: 2
  end

  test 'team order process' do
    @team_order.correspondences.destroy_all
    @team_order.process
    assert_not @team_order.correspondences.empty?
  end
end
