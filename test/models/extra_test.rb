require 'test_helper'

class ExtraTest < ActiveSupport::TestCase
  setup do
    @portal = portals(:competition)
    @extra = extras(:one)
  end

  test 'region dataset associations' do
    assert @extra.portal == @portal
  end
end
