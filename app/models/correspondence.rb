class Correspondence < ApplicationRecord
  belongs_to :orderable, polymorphic: true
  belongs_to :user

  validates :status, inclusion: { in: CORRESPONDENCE_STATUS_TYPES }
end
