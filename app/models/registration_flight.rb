class RegistrationFlight < ApplicationRecord
  belongs_to :flight
  belongs_to :registration

  validates :flight, uniqueness: { scope: :registration, message: 'Flight Reservation already exists.' }
end
