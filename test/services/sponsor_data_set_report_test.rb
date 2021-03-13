require 'test_helper'

class SponsorDataSetReportTest < ActiveSupport::TestCase
  setup do
    competition = Competition.first
    @sponsor_dataset_report = SponsorDataSetReport.new(competition)
  end

  test 'report' do
    assert @sponsor_dataset_report.report.instance_of?(Array)
  end

  test 'unaccounted_team_data_set_count' do
    assert_raises(StandardError) do
      @sponsor_dataset_report.unaccounted_team_data_set_count
    end

    @sponsor_dataset_report.report
    assert @sponsor_dataset_report.unaccounted_team_data_set_count.instance_of?(Integer)
  end

  test 'to_csv' do
    assert @sponsor_dataset_report.to_csv.instance_of?(String)
  end
end
