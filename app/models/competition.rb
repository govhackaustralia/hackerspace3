class Competition < ApplicationRecord
  has_many :assignments, as: :assignable

  validates :year, presence: true

  def self.current
    find_or_create_by(year: Time.current.year)
  end

  def self.management_team
    current.assignments.where(title: MANAGEMENT_TEAM)
  end

  def self.site_admin
    current.assignments.where(title: ADMIN)
  end
end
