class Judgment < ApplicationRecord
  belongs_to :scorecard
  belongs_to :criterion
end
