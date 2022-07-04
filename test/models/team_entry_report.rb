require 'test_helper'

class TeamEntryReportTest < ActiveSupport::TestCase
  setup do
    @competition = competitions(:one)
  end

  test 'to_csv' do
    TeamEntryReport.new(@competition).to_csv
  end
end
