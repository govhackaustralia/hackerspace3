class Assignment < ApplicationRecord
  belongs_to :assignable, polymorphic: true
  belongs_to :user
  has_many :registrations, dependent: :destroy
  has_many :challenge_scorecards, dependent: :destroy
  has_many :peoples_scorecards, dependent: :destroy
  has_many :favourites, dependent: :destroy
  has_many :teams, through: :favourites

  validates :title, inclusion: { in: VALID_ASSIGNMENT_TITLES }
end
