# frozen_string_literal: true

require 'test_helper'

class ProjectJudgingReportTest < ActiveSupport::TestCase
  test 'to_csv' do
    assert_equal String, ProjectJudgingReport.new(challenges(:one)).to_csv.class
  end
end
