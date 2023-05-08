# == Schema Information
#
# Table name: holders
#
#  id                    :bigint           not null, primary key
#  user_id               :bigint           not null
#  competition_id        :bigint           not null
#  aws_credits_requested :boolean
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  team_status           :integer
#  profile_id            :bigint
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
