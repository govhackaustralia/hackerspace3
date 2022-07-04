require 'test_helper'

class UserRegistrationReportTest < ActiveSupport::TestCase
  setup do
    @competition = competitions(:one)
  end

  test 'report' do
    UserRegistrationReport.report(@competition).instance_of?(String)
  end
end
