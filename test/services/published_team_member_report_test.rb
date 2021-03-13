require 'test_helper'

class PublishedTeamMemberReportTest < ActiveSupport::TestCase
  setup do
    competition = Competition.first
    @report = PublishedTeamMemberReport.new(competition)
  end

  test 'to_csv' do
    @report.to_csv.instance_of?(String)
  end
end
