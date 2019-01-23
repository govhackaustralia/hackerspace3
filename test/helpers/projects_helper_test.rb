require 'test_helper'

class ProjectsHelperTest < ActionView::TestCase
  setup do
    @projects = Project.all
  end

  test 'filter_projects' do
    assert filter_projects('bah').class == Array
  end
end
