class TeamOrder < ApplicationRecord
  belongs_to :bulk_mail
  belongs_to :team

  has_many :correspondences, as: :orderable, dependent: :destroy

  validates :request_type, inclusion: { in: TEAM_ORDER_REQUEST_TYPES }
  validates :bulk_mail_id, uniqueness: {
    scope: :team_id,
    message: 'Team order already exists'
  }

  # Prepare and send e-mails for team orders.
  def process
    return if request_type == NONE

    project = team.current_project
    prepare_and_send team.leaders, project
    return if request_type == LEADER_ONLY

    prepare_and_send team.members, project
  end

  private

  # Send emails for orders.
  def prepare_and_send(users, project)
    body = bulk_mail.body
    users.each do |user|
      next unless user.me_govhack_contact

      email_body = BulkMail.correspondence_body(body, user, project)
      correspondence = correspondences.create(
        user: user, body: email_body, status: PENDING
      )
      BulkMailer.participant_email(self, correspondence, user).deliver_now unless Rails.env.test?
      correspondence.update status: SENT
    end
  end
end
