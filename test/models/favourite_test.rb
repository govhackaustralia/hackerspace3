# frozen_string_literal: true

# == Schema Information
#
# Table name: favourites
#
#  id            :bigint           not null, primary key
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  assignment_id :integer
#  holder_id     :integer
#  team_id       :integer
#
# Indexes
#
#  index_favourites_on_assignment_id  (assignment_id)
#  index_favourites_on_holder_id      (holder_id)
#  index_favourites_on_team_id        (team_id)
#
require 'test_helper'

class FavouriteTest < ActiveSupport::TestCase
  setup do
    @favourite = favourites(:one)
    @team = teams(:one)
    @holder = holders(:one)
    @assignment = assignments(:participant)
    @project = projects(:one)
  end

  test 'associations' do
    assert @favourite.team == @team
    assert @favourite.holder == @holder
    assert @favourite.assignment == @assignment
    assert @favourite.project == @project
  end

  test 'validations' do
    assert_not Favourite.create(team: @team, assignment: @assignment).persisted?
  end
end
