class BulkMail < ApplicationRecord
  belongs_to :mailable, polymorphic: true
  belongs_to :user
  has_many :team_orders, dependent: :destroy
  has_many :team_correspondences, through: :team_orders, source: :correspondences
  has_many :teams, through: :team_orders
  has_many :user_orders, dependent: :destroy
  has_many :user_correspondences, through: :user_orders, source: :correspondences

  validates :name, :from_email, :subject, presence: true
  validates :status, inclusion: { in: BULK_MAIL_STATUS_TYPES }

  # Creates Team Orders for all teams associated with a mailable (an event or
  # region)
  def create_team_orders
    mailable.teams.each do |team|
      TeamOrder.create(bulk_mail: self, team: team, request_type: NONE)
    end
  end

  # Updates Team Orders to add teams that were created after first create.
  def update_team_orders
    (mailable.teams.to_a - teams.to_a).each do |team|
      TeamOrder.create(bulk_mail: self, team: team, request_type: NONE)
    end
  end

  # Returns a collection of correspondences associated with a bulk mail.
  def correspondences
    return team_correspondences if mailable_type == 'Region'

    user_correspondences
  end

  # Processes a bulkmail out whether for team based order or user based order.
  def process
    team_process
    user_process
    update status: PROCESSED
  end

  # Fill in specific attributes of email body and return string.
  def self.correspondence_body(template, user, project = nil)
    body = template.gsub(/\{ display_name \}/, user.display_name)
    return body if project.nil?

    body = body.gsub(/\{ team_name \}/, project.team_name)
    body.gsub(/\{ project_name \}/, project.project_name)
  end

  private

  # Process Team Orders (if there ar any)
  def team_process
    teams = mailable.teams
    return if teams.empty?

    team_orders.preload(team: %i[leaders members current_project]).each do |team_order|
      team_prepare_and_send(team_order)
    end
  end

  # Prepare and send e-mails for team orders.
  def team_prepare_and_send(team_order)
    return if team_order.request_type == NONE

    project = team_order.team.current_project
    prepare_and_send(team_order.team.leaders, project, team_order)
    return if team_order.request_type == LEADER_ONLY

    prepare_and_send(team_order.team.members, project, team_order)
  end

  # Process User Orders
  def user_process
    user_order = UserOrder.find_by(bulk_mail: self)
    return if user_order.nil?

    user_order.registrations(mailable).preload(:user).each do |registration|
    end
  end

  # Send emails for orders.
  # ENHANCEMENT: Should be moved else where.
  def prepare_and_send(users, project, team_order)
    users.each do |user|
      next unless user.me_govhack_contact

      email_body = BulkMail.correspondence_body(body, user, project)
      correspondence = team_order.correspondences.create(user: user, body: email_body, status: PENDING)
      BulkMailer.participant_email(self, correspondence, user).deliver_now
      correspondence.update(status: SENT)
      user_order.process(registration, self)
    end
  end
end
