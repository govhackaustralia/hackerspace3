require 'test_helper'

class PeoplesJudgesReportTest < ActiveSupport::TestCase
  setup do
    @competition = competitions(:one)
  end

  test 'to_csv' do
    PeoplesJudgesReport.new(@competition).to_csv
  end
end
