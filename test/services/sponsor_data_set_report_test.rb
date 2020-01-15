require 'test_helper'

class SponsorDataSetReportTest < ActiveSupport::TestCase
  setup do
    competition = Competition.first
    @sponsor_dataset_report = SponsorDataSetReport.new(competition)
  end

  test 'report' do
    assert @sponsor_dataset_report.report.class == Array
  end

  test 'to_csv' do
    assert @sponsor_dataset_report.to_csv.class == String
  end
end
