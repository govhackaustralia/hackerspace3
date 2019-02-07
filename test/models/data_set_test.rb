require 'test_helper'

class DataSetTest < ActiveSupport::TestCase
  setup do
    @data_set = DataSet.first
    @region = Region.first
    @competition = Competition.first
  end

  test 'data set associations' do
    assert @data_set.region == @region
    assert @data_set.competition == @competition
  end

  test 'data set scopes' do
    assert DataSet.search('m').include? @data_set
    assert_not DataSet.search('z').include? @data_set
  end

  test 'data set validations' do
    assert_not @data_set.update(name: nil)
  end
end
