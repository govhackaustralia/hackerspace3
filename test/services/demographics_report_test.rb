require 'test_helper'

class DemographicsReportTest < ActiveSupport::TestCase
  setup do
    competition = Competition.first
    @demographics_report = DemographicsReport.new(competition, 'gender')
  end

  test 'report' do
    assert @demographics_report.report.instance_of?(Array)
  end

  test 'to_csv' do
    assert @demographics_report.to_csv.instance_of?(String)
  end

end
