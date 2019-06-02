class Sponsor < ApplicationRecord
  belongs_to :competition

  has_many :assignments, as: :assignable, dependent: :destroy
  has_many :sponsorships, dependent: :destroy
  has_many :event_partnerships, dependent: :destroy
  has_many :challenge_sponsorships, dependent: :destroy

  has_one_attached :logo

  validates :name, uniqueness: true
  validates :name, presence: true

  scope :search, lambda { |term|
    where 'name ILIKE ? OR description ILIKE ?', "%#{term}%", "%#{term}%"
  }

  # Returns true if a user is able to see a sponsor's settings.
  # ENHANCEMENT: Move to Controller.
  def show_privileges?(user)
    user.assignments.where(title: SPONSOR_CONTACT).any?
  end

  # Returns all the assignments able to modify and interact with a sponsor.
  # ENHANCEMENT: Move to Controller.
  def admin_assignments
    collected = assignments.where(title: SPONSOR_ADMIN).to_a
    collected << competition.admin_assignments
    collected << Assignment.where(title: REGION_ADMIN).to_a
    collected.flatten
  end
end
