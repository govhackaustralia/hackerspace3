class Challenge < ApplicationRecord
  belongs_to :competition
  belongs_to :region

  has_many :assignments, as: :assignable, dependent: :destroy
  has_many :users, through: :assignments
  has_many :entries, dependent: :destroy
  has_many :teams, through: :entries
  has_many :published_teams, -> { published }, through: :entries, source: :team
  has_many :published_projects_by_name, -> { order(:project_name) }, through: :published_teams, source: :current_project
  has_many :challenge_sponsorships, dependent: :destroy
  has_many :sponsors, through: :challenge_sponsorships
  has_many :challenge_data_sets, dependent: :destroy
  has_many :data_sets, through: :challenge_data_sets

  has_one_attached :image
  has_one_attached :pdf
  has_one_attached :pdf_preview

  scope :approved, -> { where(approved: true) }

  validates :name, presence: true, uniqueness: true

  after_save :update_identifier

  # ENHANCEMENT: This should be in active record relation but can't pass
  # parameter. eg
  # has_many entries_at, -> (checkpoint) { where('checkpoint_id = ?', checkpoint.id) }
  def entries_at(checkpoint)
    entries.where(checkpoint: checkpoint)
  end

  # Returns an array of all admin assignments associated with challenges in
  # particular competition.
  # ENHANCEMENT: This should probably be in a controller.
  def admin_assignments
    competition = Competition.current
    collected = competition.admin_assignments
    collected << competition.assignments.where(title: CHIEF_JUDGE).to_a
    collected << region.admin_assignments
    collected.flatten
  end

  # Returns a query object of the teams that are able to join a competition.
  def eligible_teams
    if region.national?
      competition.teams
    else
      region.teams
    end
  end

  # Returns the type of region that a challenge is associated with.
  def type
    region.national? ? NATIONAL : REGIONAL
  end

  require 'csv'

  # Compiles a CSV file of all challenges.
  # ENHANCEMENT: This should be in a helper object or own model.
  def self.to_csv(options = {})
    competition = Competition.current
    challenge_columns = %w[id name short_desc long_desc eligibility video_url created_at updated_at]
    CSV.generate(options) do |csv|
      csv << (%w[region_name competition_year] + challenge_columns + %w[sponsors])
      all.preload(:region, :sponsors).each do |challenge|
        csv << challenge_csv_line(challenge, competition, challenge_columns)
      end
    end
  end

  # Compiles a single entry for the CSV file.
  # ENHANCEMENT: This should be in a helper object or own model.
  def self.challenge_csv_line(challenge, competition, challenge_columns)
    values = [challenge.region.name, competition.year]
    values += challenge.attributes.values_at(*challenge_columns)
    values << challenge.sponsors.pluck(:name)
  end

  # Assorts challenges in a key value pair object.
  # ENHANCEMENT: Remove and replace with preload()
  def self.id_challenges(challenges)
    id_challenges = {}
    challenges.each { |challenge| id_challenges[challenge.id] = challenge }
    id_challenges
  end

  private

  # Generates a unique name and updates the identifier field.
  def update_identifier
    new_identifier = uri_pritty name
    new_identifier = uri_pritty "#{name}-#{id}" if already_there? Challenge, new_identifier, self
    update_columns identifier: new_identifier
  end
end
