require 'test_helper'

class CompetitionsHelperTest < ActionView::TestCase
  setup do
    @competition = Competition.first
    @region_privileges = true
  end

  test 'competition_started_or_region_privileges?' do
    assert competition_started_or_region_privileges?
  end

  test 'in_form_or_comp_started_or_region_privileges?' do
    assert in_form_or_comp_started_or_region_privileges?
  end

  test 'in_form_or_comp_window_or_region_privileges?' do
    assert in_form_or_comp_window_or_region_privileges?
  end
end
