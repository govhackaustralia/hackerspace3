require 'test_helper'

class ProjectScorecardDuplicatesTest < ActiveSupport::TestCase
  test 'report' do
    ProjectScorecardDuplicates.report
  end

  test 'clean_up!' do
    ProjectScorecardDuplicates.clean_up!
  end
end
