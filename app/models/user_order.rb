class UserOrder < ApplicationRecord
  belongs_to :bulk_mail

  has_many :correspondences, as: :orderable, dependent: :destroy

  # Returns the registrations of a user_order given it's request type.
  def registrations(event)
    case request_type
    when INVITED
      event.registrations.where(status: INVITED)
    when ATTENDING
      event.registrations.where(status: ATTENDING)
    when INVITED_AND_ATTENDING
      event.registrations.where(status: [INVITED, ATTENDING])
    else
      []
    end
  end
end
