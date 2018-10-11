class Correspondence < ApplicationRecord
  belongs_to :orderable, polymorphic: true
  belongs_to :user

  validates :status, inclusion: { in: CORRESPONDENCE_STATUS_TYPES }

  def self.id_user_correspondences(bulk_mail)
    id_user_correspondences = {}
    bulk_mail.correspondences.each do |correspondence|
      id_user_correspondences[correspondence.user_id] = correspondence
    end
    id_user_correspondences
  end
end
