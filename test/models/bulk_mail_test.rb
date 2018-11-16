require 'test_helper'

class BulkMailTest < ActiveSupport::TestCase
  setup do
    @bulk_mail = BulkMail.first
    @user = User.first
    @region = Region.first
    @team_order = TeamOrder.first
    @user_order = UserOrder.first
    @team_correspondence = Correspondence.first
    @user_correspondence = Correspondence.second
  end

  test 'bulkmail associations' do
    assert @bulk_mail.user == @user
    assert @bulk_mail.mailable == @region
    assert @bulk_mail.team_orders.include? @team_order
    assert @bulk_mail.user_orders.include? @user_order
    assert @bulk_mail.team_correspondences.include? @team_correspondence
    assert @bulk_mail.user_correspondences.include? @user_correspondence
  end
end
