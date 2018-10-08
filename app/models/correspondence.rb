class Correspondence < ApplicationRecord
  belongs_to :mail_order
  has_one :bulk_mail, through: :mail_order
  belongs_to :user

  validates :mail_order_id, uniqueness: { scope: :user_id, message: 'Correspondence already exists.' }
  validates :status, inclusion: { in: CORRESPONDENCE_STATUS_TYPES }

  def self.id_user_correspondences(bulk_mail)
    id_user_correspondences = {}
    bulk_mail.correspondences.each do |correspondence|
      id_user_correspondences[correspondence.user_id] = correspondence
    end
    id_user_correspondences
  end
end
