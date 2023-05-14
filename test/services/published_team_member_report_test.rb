# frozen_string_literal: true

require 'test_helper'

class PublishedTeamMemberReportTest < ActiveSupport::TestCase
  setup do
    competition = competitions(:one)
    @report = PublishedTeamMemberReport.new(competition)
  end

  test 'to_csv' do
    @report.to_csv.instance_of?(String)
  end
end
