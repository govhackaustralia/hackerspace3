class Assignment < ApplicationRecord
  belongs_to :assignable, polymorphic: true
  belongs_to :user
  has_many :registrations
  has_many :challenge_judgements

  validates :title, inclusion: { in: VALID_ASSIGNMENT_TITLES }
end
