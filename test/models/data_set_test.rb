require 'test_helper'

class DataSetTest < ActiveSupport::TestCase
  setup do
    @data_set = data_sets(:one)
    @region = Region.first
    @competition = competitions(:one)
    @challenge_data_set = challenge_data_sets(:one)
    @challenge = challenges(:one)
    @sponsor = Sponsor.first
  end

  test 'data set associations' do
    assert @data_set.region == @region
    assert @data_set.competition == @competition
    assert @data_set.challenge_data_sets.include? @challenge_data_set
    assert @data_set.challenges.include? @challenge
    assert @data_set.sponsors.include? @sponsor
    assert @data_set.visits.include? visits(:data_set)

    @data_set.destroy!

    assert_raises(ActiveRecord::RecordNotFound) { visits(:data_set).reload }
  end

  test 'data set scopes' do
    assert DataSet.search('m').include? @data_set
    assert_not DataSet.search('z').include? @data_set
    assert @competition.data_sets.search('m').include? @data_set
  end

  test 'data set validations' do
    assert_not @data_set.update(name: nil)
  end
end
