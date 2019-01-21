class Flight < ApplicationRecord
  belongs_to :event
  has_many :registration_flights, dependent: :destroy

  scope :inbound, -> { where(direction: INBOUND) }
  scope :outbound, -> { where(direction: OUTBOUND) }

  validates :direction, inclusion: { in: FLIGHT_DIRECTIONS }
end
