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

  # Process Team Orders
  def team_process
    teams = mailable.teams
    return if teams.empty?

    team_orders.preload(
      team: %i[leaders members current_project]
    ).each(&:process)
  end

  # Process User Orders
  def user_process
    user_order = UserOrder.find_by(bulk_mail: self)
    return if user_order.nil?

    user_order.registrations(mailable).preload(:user).each do |registration|
      user_order.process(registration, self)
    end
  end
end
