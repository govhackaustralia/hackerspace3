class Competition < ApplicationRecord
  has_many :assignments, as: :assignable

  validates :year, presence: true

  def self.current
    find_or_create_by(year: Time.current.year)
  end
end
