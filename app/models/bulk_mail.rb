class BulkMail < ApplicationRecord
  belongs_to :region
  belongs_to :user
  has_many :mail_orders, dependent: :destroy

  validates :name, presence: true

  def create_mail_orders
    region.teams.each do |team|
      MailOrder.create(bulk_mail: self, team: team, request_type: NONE)
    end
  end
end
