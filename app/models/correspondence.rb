class Correspondence < ApplicationRecord
  belongs_to :orderable, polymorphic: true
  belongs_to :user

  validates :status, inclusion: { in: CORRESPONDENCE_STATUS_TYPES }

  def bulk_mail
    orderable.bulk_mail
  end
end
