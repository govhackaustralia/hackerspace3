require 'test_helper'

class Admin::BulkMails::CorrespondencesHelperTest < ActionView::TestCase
  setup do
    @correspondences = Correspondence.all
  end

  test 'correspondence_with' do
    assert correspondence_with(1).instance_of?(Correspondence)
  end
end
