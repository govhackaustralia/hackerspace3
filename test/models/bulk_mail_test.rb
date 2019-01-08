require 'test_helper'

class BulkMailTest < ActiveSupport::TestCase
  setup do
    @region_bulk_mail = BulkMail.first
    @event_bulk_mail = BulkMail.second
    @user = User.first
    @region = Region.first
    @team_order = TeamOrder.first
    @user_order = UserOrder.first
    @team_correspondence = Correspondence.first
    @user_correspondence = Correspondence.second
    @team = Team.first
  end

  test 'bulkmail associations' do
    assert @region_bulk_mail.user == @user
    assert @region_bulk_mail.mailable == @region
    assert @region_bulk_mail.team_orders.include? @team_order
    assert @event_bulk_mail.user_orders.include? @user_order
    assert @region_bulk_mail.team_correspondences.include? @team_correspondence
    assert @event_bulk_mail.user_correspondences.include? @user_correspondence
    assert @region_bulk_mail.teams.include? @team
    @region_bulk_mail.destroy
    assert_raises(ActiveRecord::RecordNotFound) { @team_order.reload }
    @event_bulk_mail.destroy
    assert_raises(ActiveRecord::RecordNotFound) { @user_order.reload }
  end

  test 'bulkmail validations' do
    bulk_mail = @region.bulk_mails.create(name: 'test', subject: 'test', user: @user, status: BULK_MAIL_STATUS_TYPES.sample)
    assert_not bulk_mail.persisted?
    bulk_mail = @region.bulk_mails.create(name: 'test', from_email: 'test@example.com', subject: 'test', user: @user, status: BULK_MAIL_STATUS_TYPES.sample)
    assert bulk_mail.persisted?
  end
end
