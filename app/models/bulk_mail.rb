class BulkMail < ApplicationRecord
  belongs_to :mailable, polymorphic: true
  belongs_to :user
  has_many :team_orders, dependent: :destroy
  has_many :correspondences, through: :team_orders

  validates :name, :from_email, :subject, presence: true
  validates :status, inclusion: { in: BULK_MAIL_STATUS_TYPES }

  def create_team_orders
    mailable.teams.each do |team|
      TeamOrder.create(bulk_mail: self, team: team, request_type: NONE)
    end
  end

  def process
    teams = mailable.teams
    id_team_projects = Team.id_teams_projects(teams)
    id_team_participants = Team.id_team_participants(teams)
    team_orders.each do |team_order|
      next if team_order.request_type == NONE
      project = id_team_projects[team_order.team_id][:current_project]
      prepare_and_send(id_team_participants[team_order.team_id][:leaders], project, team_order)
      next if team_order.request_type == LEADER_ONLY
      prepare_and_send(id_team_participants[team_order.team_id][:members], project, team_order)
    end
    update(status: PROCESSED)
  end

  def self.correspondence_body(template, user, project)
    body = template.gsub(/\{ display_name \}/, user.display_name)
    body = body.gsub(/\{ team_name \}/, project.team_name)
    body.gsub(/\{ project_name \}/, project.project_name)
  end

  private

  def prepare_and_send(users, project, team_order)
    users.each do |user|
      next unless user.me_govhack_contact
      email_body = BulkMail.correspondence_body(body, user, project)
      correspondence = team_order.correspondences.create(user: user, body: email_body, status: PENDING)
      BulkMailer.participant_email(self, correspondence, user).deliver_now
      correspondence.update(status: SENT)
    end
  end
end
