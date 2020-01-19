require 'test_helper'

class TeamCsvReporterTest < ActiveSupport::TestCase
  setup do
    @competition = Competition.first
  end

  test 'all_members_to_csv' do
    TeamCsvReporter.new(@competition).members_to_csv.class == String
  end
end
