class ChallengeScorecard < ApplicationRecord
  belongs_to :assignment
  belongs_to :entry
end
