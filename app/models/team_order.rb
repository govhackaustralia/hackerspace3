class TeamOrder < ApplicationRecord
  belongs_to :bulk_mail
  belongs_to :team
  has_many :correspondences, as: :orderable, dependent: :destroy

  validates :request_type, inclusion: { in: TEAM_ORDER_REQUEST_TYPES }
end
