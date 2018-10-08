class MailOrder < ApplicationRecord
  belongs_to :bulk_mail
  belongs_to :team
  has_many :correspondences, dependent: :destroy

  validates :bulk_mail_id, uniqueness: { scope: :team_id,
                                          message: 'Mail Order already exists.' }
  validates :request_type, inclusion: { in: MAIL_ORDER_REQUEST_TYPES }
end
