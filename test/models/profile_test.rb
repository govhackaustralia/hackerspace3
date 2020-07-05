require 'test_helper'

class ProfileTest < ActiveSupport::TestCase
  setup do
    @profile = profiles(:one)
    @user = users(:one)
  end

  test 'associations' do
    assert @profile.user == @user
  end

  test 'enums' do
    assert Profile.first_peoples.is_a? Hash
    assert Profile.disabilities.is_a? Hash
    assert Profile.educations.is_a? Hash
    assert Profile.employments.is_a? Hash
    assert Profile.ages.is_a? Hash
  end
end
