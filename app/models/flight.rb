class Flight < ApplicationRecord
  belongs_to :event
  has_many :registration_flights, dependent: :destroy

  scope :inbound, -> { find_by(direction: INBOUND) }
  scope :outbound, -> { find_by(direction: OUTBOUND) }

  validates :direction, inclusion: { in: FLIGHT_DIRECTIONS }
end
