class Flight < ApplicationRecord
  belongs_to :event
  has_many :registration_flights, dependent: :destroy
  validates :direction, inclusion: { in: FLIGHT_DIRECTIONS }
end
