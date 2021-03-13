require 'test_helper'

class UserRegistrationReportTest < ActiveSupport::TestCase
  setup do
    @competition = Competition.first
  end

  test 'report' do
    UserRegistrationReport.report(@competition).instance_of?(String)
  end
end
