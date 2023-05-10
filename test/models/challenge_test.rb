# frozen_string_literal: true

# == Schema Information
#
# Table name: challenges
#
#  id          :bigint           not null, primary key
#  approved    :boolean          default(FALSE)
#  eligibility :text
#  identifier  :string
#  long_desc   :text
#  name        :string
#  nation_wide :boolean
#  short_desc  :text
#  video_url   :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  region_id   :integer
#
# Indexes
#
#  index_challenges_on_approved     (approved)
#  index_challenges_on_identifier   (identifier)
#  index_challenges_on_nation_wide  (nation_wide)
#  index_challenges_on_region_id    (region_id)
#
require 'test_helper'

class ChallengeTest < ActiveSupport::TestCase
  setup do
    @challenge = challenges(:one)
    @competition = competitions(:one)
    @region = regions(:national)
    @assignment = assignments(:judge)
    @user = users(:two)
    @entry = entries(:one)
    @checkpoint = checkpoints(:one)
    @team = teams(:one)
    @challenge_sponsorship = challenge_sponsorships(:one)
    @sponsor = sponsors(:one)
    @challenge_data_set = challenge_data_sets(:one)
    @data_set = data_sets(:one)
    @regional_challenge = challenges(:three)
  end

  test 'challenge associations' do
    assert @challenge.competition == @competition
    assert @challenge.region == @region
    assert @challenge.assignments.include? @assignment
    assert @challenge.judge_users.include? @user
    assert @challenge.entries.include? @entry
    assert @challenge.published_entries.include? @entry
    assert @challenge.entries_at(@checkpoint).include? @entry
    assert @challenge.teams.include? @team
    assert @challenge.challenge_sponsorships.include? @challenge_sponsorship
    assert @challenge.sponsors.include? @sponsor
    assert @challenge.sponsors_with_logos.include? @sponsor
    assert @challenge.challenge_data_sets.include? @challenge_data_set
    assert @challenge.data_sets.include? @data_set
    @challenge.destroy
    assert_raises(ActiveRecord::RecordNotFound) { @assignment.reload }
    assert_raises(ActiveRecord::RecordNotFound) { @entry.reload }
    assert_raises(ActiveRecord::RecordNotFound) { @challenge_sponsorship.reload }
    assert_raises(ActiveRecord::RecordNotFound) { @challenge_data_set.reload }
  end

  test 'challenge scopes' do
    assert Challenge.approved.include? @challenge
    assert Challenge.not_unapproved.include? @challenge
    @challenge.update! approved: false
    assert Challenge.approved.exclude? @challenge
    assert Challenge.not_unapproved.exclude? @challenge
    @challenge.update! approved: nil
    assert Challenge.approved.exclude? @challenge
    assert Challenge.not_unapproved.include? @challenge
    assert Challenge.nation_wides.include? @regional_challenge
    assert Challenge.nation_wides.exclude? @challenge
  end

  test 'challenge validations' do
    assert_not @challenge.update(name: nil)
    challenge2 = challenges(:two)
    assert_not @challenge.update(name: challenge2.name)
  end

  test 'only_regional_challenges_can_be_marked_nation_wide' do
    assert_raises(ActiveRecord::RecordInvalid) do
      @challenge.update! nation_wide: true
    end
    @regional_challenge.update nation_wide: true
    assert @regional_challenge.reload.nation_wide
  end
end
