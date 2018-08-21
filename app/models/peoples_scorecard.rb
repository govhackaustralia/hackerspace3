class PeoplesScorecard < ApplicationRecord
  belongs_to :assignment
  belongs_to :team
end
