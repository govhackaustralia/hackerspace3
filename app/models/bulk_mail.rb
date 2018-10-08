class BulkMail < ApplicationRecord
  belongs_to :region
  belongs_to :user
  has_many :mail_orders, dependent: :destroy
  has_many :correspondences, through: :mail_orders

  validates :name, :from_email, :subject, presence: true
  validates :status, inclusion: { in: BULK_MAIL_STATUS_TYPES }

  def create_mail_orders
    region.teams.each do |team|
      MailOrder.create(bulk_mail: self, team: team, request_type: NONE)
    end
  end

  def process
    teams = region.teams
    id_team_projects = Team.id_teams_projects(teams)
    id_team_participants = Team.id_team_participants(teams)
    mail_orders.each do |mail_order|
      next if mail_order.request_type == NONE
      project = id_team_projects[mail_order.team_id][:current_project]
      prepare_and_send(id_team_participants[mail_order.team_id][:leaders], project, mail_order)
      next if mail_order.request_type == LEADER_ONLY
      prepare_and_send(id_team_participants[mail_order.team_id][:members], project, mail_order)
    end
    update(status: PROCESSED)
  end

  def self.correspondence_body(template, user, project)
    body = template.gsub(/\{ display_name \}/, user.display_name)
    body = body.gsub(/\{ team_name \}/, project.team_name)
    body.gsub(/\{ project_name \}/, project.project_name)
  end

  private

  def prepare_and_send(users, project, mail_order)
    users.each do |user|
      next unless user.me_govhack_contact
      email_body = BulkMail.correspondence_body(body, user, project)
      correspondence = mail_order.correspondences.create(user: user, body: email_body, status: PENDING)
      BulkMailer.participant_email(self, correspondence, user).deliver_now
      correspondence.update(status: SENT)
    end
  end
end
