class Scorecard < ApplicationRecord
  has_many :judgments
  belongs_to :assignment
  belongs_to :judgeable, polymorphic: true
end
