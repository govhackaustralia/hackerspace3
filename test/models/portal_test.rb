require 'test_helper'

class PortalTest < ActiveSupport::TestCase
  setup do
    @portal = portals(:one)
    @dataset = datasets(:one)
    @competition = competitions(:one)
    @extra = extras(:one)
  end

  test 'portal associations' do
    assert @portal.dataset == @dataset
    assert @portal.extra == @extra

    @portal.destroy
    assert_raises(ActiveRecord::RecordNotFound) { @extra.reload }
  end

  test 'region data set validations' do
    portal = Portal.create(portable: @competition, dataset: @dataset)
    assert_not portal.persisted?
  end
end
