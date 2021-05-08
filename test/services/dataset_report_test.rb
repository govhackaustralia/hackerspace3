require 'test_helper'

class DatesetReportTest < ActiveSupport::TestCase
  setup do
    competition = competitions(:one)
    @dataset_report = DatasetReport.new(competition.datasets)
  end

  test 'to_csv' do
    assert @dataset_report.to_csv.instance_of?(String)
  end
end
