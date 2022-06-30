require 'test_helper'

class AwsCreditsRequestedReportTest < ActiveSupport::TestCase
  setup do
    @competition = competitions(:one)
    @report = AwsCreditsRequestedReport.new @competition
  end

  test 'competition_count' do
    assert @report.competition_count == @competition.competition_registrations.aws_credits_requested.count
  end

  test 'region_count' do
    region = Region.second
    count = 0
    region.events.competitions.each { |event| count += event.registrations.aws_credits_requested.count }
    assert @report.region_count(region) == count
  end

  test 'event_count' do
    event = events(:competition)
    assert @report.event_count(event) == event.registrations.aws_credits_requested.count
  end
end
