# frozen_string_literal: true

# == Schema Information
#
# Table name: datasets
#
#  id          :bigint           not null, primary key
#  name        :string
#  url         :string
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'test_helper'

class DatasetTest < ActiveSupport::TestCase
  setup do
    @dataset = datasets(:one)
  end

  test 'dataset scopes' do
    assert Dataset.search('m').include? @dataset
    assert_not Dataset.search('z').include? @dataset
  end

  test 'dataset validations' do
    assert_not @dataset.update(name: nil)
  end
end
