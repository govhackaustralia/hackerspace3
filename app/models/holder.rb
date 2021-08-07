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
