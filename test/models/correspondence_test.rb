require 'test_helper'

class CorrespondenceTest < ActiveSupport::TestCase
  setup do
    @team_correspondence = Correspondence.first
    @correspondence = Correspondence.first
    @team_order = TeamOrder.first
    @user_correspondence = Correspondence.second
    @user_order = UserOrder.first
    @user = User.first
  end

  test 'correspondence associations' do
    assert @team_correspondence.orderable == @team_order
    assert @user_correspondence.orderable == @user_order
    assert @correspondence.user == @user
  end

  test 'correspondence validations' do
    assert_not @correspondence.update(status: 'Test')
    assert @correspondence.update(status: CORRESPONDENCE_STATUS_TYPES.sample)
  end
end
