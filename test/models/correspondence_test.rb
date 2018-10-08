require 'test_helper'

class CorrespondenceTest < ActiveSupport::TestCase
  setup do
    @correspondence = Correspondence.first
    @mail_order = MailOrder.first
    @user = User.first
  end

  test 'correspondence associations' do
    assert @correspondence.mail_order == @mail_order
    assert @correspondence.user == @user
  end
end
