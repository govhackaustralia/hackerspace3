require 'test_helper'

class TeamCsvReporterTest < ActiveSupport::TestCase
  setup do
    @competition = Competition.first
  end

  test 'all_members_to_csv' do
    TeamCsvReporter.all_members_to_csv(@competition).class == String
  end
end
