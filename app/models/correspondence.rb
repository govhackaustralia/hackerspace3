class Correspondence < ApplicationRecord
  belongs_to :orderable, polymorphic: true
  belongs_to :user

  validates :status, inclusion: { in: CORRESPONDENCE_STATUS_TYPES }
  after_create_commit { CorrespondenceBroadcastJob.perform_later(self) }
  after_update_commit { CorrespondenceBroadcastJob.perform_later(self) }

  def bulk_mail
    orderable.bulk_mail
  end
end
