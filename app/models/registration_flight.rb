class RegistrationFlight < ApplicationRecord
  belongs_to :flight
  belongs_to :registration
end
