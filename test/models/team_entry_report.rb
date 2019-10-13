require 'test_helper'

class TeamEntryReportTest < ActiveSupport::TestCase
  setup do
    @competition = Competition.first
  end

  test 'to_csv' do
    TeamEntryReport.new(@competition).to_csv
  end
end
