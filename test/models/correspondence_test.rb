require 'test_helper'

class CorrespondenceTest < ActiveSupport::TestCase
  setup do
    @correspondence = Correspondence.first
    @team_order = TeamOrder.first
    @user = User.first
  end

  test 'correspondence associations' do
    assert @correspondence.orderable == @team_order
    assert @correspondence.user == @user
  end
end
