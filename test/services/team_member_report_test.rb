# frozen_string_literal: true

require 'test_helper'

class TeamMemberReportTest < ActiveSupport::TestCase
  setup do
    @competition = competitions(:one)
  end

  test 'to_csv' do
    TeamMemberReport.new(@competition).to_csv.instance_of?(String)
  end
end
