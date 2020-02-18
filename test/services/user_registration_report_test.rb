require 'test_helper'

class UserRegistrationReportTest < ActiveSupport::TestCase
  setup do
    @competition = Competition.first
  end

  test 'report' do
    UserRegistrationReport.report(@competition).class == String
  end
end
