require 'test_helper'

class EmploymentStatusTest < ActiveSupport::TestCase
  test 'employment_status associations' do
    assert employment_statuses(:one).profile == profiles(:one)
  end
end
