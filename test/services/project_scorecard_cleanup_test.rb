require 'test_helper'

class ProjectScorecardCleanupTest < ActiveSupport::TestCase
  test 'cleanup!' do
    ProjectScorecardCleanup.cleanup!
  end
end
