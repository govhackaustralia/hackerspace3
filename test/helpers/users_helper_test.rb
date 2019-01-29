require 'test_helper'

class UsersHelperTest < ActionView::TestCase
  setup do
    @assignment_titles = COMP_ADMIN + EVENT_PRIVILEGES + SPONSOR_PRIVILEGES + [CHIEF_JUDGE, JUDGE, SPONSOR_CONTACT]
  end

  test 'permission methods' do
    assert user_has_admin_privilieges?
    assert user_has_event_privileges?
    assert user_has_sponsor_privileges?
    assert user_is_chief_judge?
    assert user_is_a_judge?
    assert user_is_a_sponsor_contact?
  end
end
