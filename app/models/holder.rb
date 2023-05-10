# frozen_string_literal: true

# == Schema Information
#
# Table name: holders
#
#  id                    :bigint           not null, primary key
#  aws_credits_requested :boolean
#  team_status           :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  competition_id        :bigint           not null
#  profile_id            :bigint
#  user_id               :bigint           not null
#
# Indexes
#
#  index_holders_on_aws_credits_requested  (aws_credits_requested)
#  index_holders_on_competition_id         (competition_id)
#  index_holders_on_profile_id             (profile_id)
#  index_holders_on_team_status            (team_status)
#  index_holders_on_user_id                (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (competition_id => competitions.id)
#  fk_rails_...  (profile_id => profiles.id)
#  fk_rails_...  (user_id => users.id)
#
class Holder < ApplicationRecord
  belongs_to :user
  belongs_to :profile
  belongs_to :competition

  enum team_status: {
    looking_for_team_members: 0,
    working_solo: 1,
    team_full: 2,
    in_team: 3
  }
end
