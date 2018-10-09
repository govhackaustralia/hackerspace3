class Flight < ApplicationRecord
  belongs_to :event

  validates :direction, inclusion: { in: FLIGHT_DIRECTIONS }
end
