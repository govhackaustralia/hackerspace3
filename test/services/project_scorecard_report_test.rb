require 'test_helper'

class ProjectScorecardReportTest < ActiveSupport::TestCase
  setup do
    @competition = Competition.last
  end

  test 'report' do
    ProjectScorecardReport.new(@competition).report
  end
end
