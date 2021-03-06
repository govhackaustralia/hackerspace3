require 'test_helper'

class DataSetTest < ActiveSupport::TestCase
  setup do
    @data_set = DataSet.first
    @region = Region.first
    @competition = Competition.first
    @challenge_data_set = ChallengeDataSet.first
    @challenge = Challenge.first
    @sponsor = Sponsor.first
  end

  test 'data set associations' do
    assert @data_set.region == @region
    assert @data_set.competition == @competition
    assert @data_set.challenge_data_sets.include? @challenge_data_set
    assert @data_set.challenges.include? @challenge
    assert @data_set.sponsors.include? @sponsor
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
