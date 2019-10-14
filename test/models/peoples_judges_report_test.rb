require 'test_helper'

class PeoplesJudgesReportTest < ActiveSupport::TestCase
  setup do
    @competition = Competition.first
  end

  test 'to_csv' do
    PeoplesJudgesReport.new(@competition).to_csv
  end
end
