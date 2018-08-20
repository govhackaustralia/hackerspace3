class Challenge < ApplicationRecord
  has_many :assignments, as: :assignable, dependent: :destroy
  belongs_to :competition
  belongs_to :region
  has_many :sponsorships, as: :sponsorable
  has_many :entries

  validates :name, presence: true
  validates :name, uniqueness: true

  def admin_assignments
    competition = Competition.current
    collected = competition.admin_assignments
    collected << competition.assignments.where(title: CHIEF_JUDGE).to_a
    collected << region.admin_assignments
    collected.flatten
  end
end
